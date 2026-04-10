import 'package:aconsia_app/chat/controllers/create_or_get_session/create_or_get_session_provider.dart';
import 'package:aconsia_app/chat/controllers/mark_all_messages_as_read/mark_all_messages_as_read_provider.dart';
import 'package:aconsia_app/chat/controllers/reset_unread_count/reset_unread_count_provider.dart';
import 'package:aconsia_app/chat/controllers/send_message/send_message_provider.dart';
import 'package:aconsia_app/chat/controllers/stream_messages/post_stream_messages_provider.dart';
import 'package:aconsia_app/chat/domain/usecases/create_or_get_session.dart';
import 'package:aconsia_app/chat/domain/usecases/mark_all_messages_as_read.dart';
import 'package:aconsia_app/chat/domain/usecases/reset_unread_count.dart';
import 'package:aconsia_app/chat/domain/usecases/send_message.dart';
import 'package:aconsia_app/core/providers/firebase_provider.dart';
import 'package:aconsia_app/core/main/data/models/pasien_profile_model.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/ui/tokens/ui_typography.dart';
import 'package:aconsia_app/core/utils/extensions/build_context_ext.dart';
import 'package:aconsia_app/presentation/pasien/main/widgets/pasien_main_shell_scope.dart';
import 'package:aconsia_app/presentation/pasien/profile/controllers/get_pasien_profile/fetch_pasien_profile_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

final _dokterPublicProfileProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>?, String>((ref, dokterId) async {
  if (dokterId.trim().isEmpty) return null;
  final firestore = ref.read(firebaseFirestoreProvider);
  final doc = await firestore.collection('dokter_profiles').doc(dokterId).get();
  if (!doc.exists) return null;
  return doc.data();
});

class DokterPasienChatPage extends ConsumerStatefulWidget {
  const DokterPasienChatPage({
    super.key,
    required this.role,
    this.pasienId,
    this.dokterId,
    this.title,
    this.embeddedInMainShell = false,
  });

  final String role; // 'pasien' or 'dokter'
  final String? pasienId;
  final String? dokterId;
  final String? title;
  final bool embeddedInMainShell;

  @override
  ConsumerState<DokterPasienChatPage> createState() =>
      _DokterPasienChatPageState();
}

class _DokterPasienChatPageState extends ConsumerState<DokterPasienChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final _timeFormat = DateFormat('HH:mm');

  String? _sessionId;
  bool _isCreatingSession = false;
  bool _isSending = false;
  bool _isMarkingRead = false;
  String? _sessionError;

  bool get _isPasienRole => widget.role == 'pasien';

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _ensureSession({
    required String pasienId,
    required String dokterId,
  }) async {
    if (_sessionId != null || _isCreatingSession) return;

    setState(() {
      _isCreatingSession = true;
      _sessionError = null;
    });

    final usecase = ref.read(createOrGetSessionProvider);
    final result = await usecase(
      CreateOrGetSessionParams(
        pasienId: pasienId,
        dokterId: dokterId,
      ),
    );

    if (!mounted) return;

    result.fold(
      (error) {
        setState(() {
          _sessionError = error;
          _isCreatingSession = false;
        });
      },
      (session) {
        setState(() {
          _sessionId = session.id;
          _isCreatingSession = false;
        });
        _markCurrentRoomAsRead();
      },
    );
  }

  Future<void> _markCurrentRoomAsRead() async {
    if (_sessionId == null || _isMarkingRead) return;
    final currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (currentUid.isEmpty) return;

    _isMarkingRead = true;
    try {
      final markAllUsecase = ref.read(markAllMessagesAsReadProvider);
      await markAllUsecase(
        MarkAllMessagesAsReadParams(
          sessionId: _sessionId!,
          receiverId: currentUid,
        ),
      );

      final resetUsecase = ref.read(resetUnreadCountProvider);
      await resetUsecase(
        ResetUnreadCountParams(
          sessionId: _sessionId!,
          role: widget.role,
        ),
      );
    } finally {
      _isMarkingRead = false;
    }
  }

  Future<void> _sendMessage({
    required String senderId,
  }) async {
    if (_isSending || _sessionId == null) return;
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _isSending = true;
    });

    final usecase = ref.read(sendMessageProvider);
    final result = await usecase(
      SendMessageParams(
        sessionId: _sessionId!,
        senderId: senderId,
        senderRole: widget.role,
        message: text,
      ),
    );

    if (!mounted) return;

    result.fold(
      (error) {
        context.showErrorSnackbar(context, error);
      },
      (_) {
        _messageController.clear();
        _scrollToBottom();
      },
    );

    setState(() {
      _isSending = false;
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (currentUid.isEmpty) {
      return _buildScaffold(
        title: widget.title ?? 'Chat Dokter-Pasien',
        body: _buildInfoState(
          icon: Icons.lock_outline_rounded,
          title: 'Sesi login tidak ditemukan',
          subtitle: 'Silakan login ulang untuk menggunakan fitur chat.',
        ),
      );
    }

    final resolvedPasienId =
        _isPasienRole ? currentUid : (widget.pasienId ?? '');
    final pasienProfileAsync =
        ref.watch(fetchPasienProfileProvider(pasienId: resolvedPasienId));

    if (!_isPasienRole && resolvedPasienId.isEmpty) {
      return _buildScaffold(
        title: widget.title ?? 'Chat dengan Pasien',
        body: _buildInfoState(
          icon: Icons.error_outline_rounded,
          title: 'Pasien belum dipilih',
          subtitle:
              'Buka chat dari detail pasien agar sistem dapat menentukan room yang tepat.',
        ),
      );
    }

    final pasienProfile = pasienProfileAsync.value;
    final dokterId =
        _isPasienRole ? (pasienProfile?.dokterId ?? '') : currentUid;
    final dokterPublicData =
        _isPasienRole ? ref.watch(_dokterPublicProfileProvider(dokterId)).valueOrNull : null;

    final peerName = _isPasienRole
        ? _resolveDokterNameFromPublicProfile(dokterPublicData)
        : _resolvePasienName(pasienProfile, widget.title);
    final pageTitle = _isPasienRole ? 'Hubungi Dokter' : 'Chat Pasien';

    if (_isPasienRole &&
        pasienProfileAsync.isLoading &&
        (pasienProfile == null)) {
      return _buildScaffold(
        title: pageTitle,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_isPasienRole && dokterId.isEmpty) {
      return _buildScaffold(
        title: pageTitle,
        body: _buildInfoState(
          icon: Icons.support_agent_rounded,
          title: 'Dokter belum ditugaskan',
          subtitle:
              'Silakan pilih dokter pada profil Anda terlebih dahulu agar chat bisa digunakan.',
        ),
      );
    }

    if (_sessionId == null && !_isCreatingSession && _sessionError == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _ensureSession(
          pasienId: resolvedPasienId,
          dokterId: dokterId,
        );
      });
    }

    if (_isCreatingSession) {
      return _buildScaffold(
        title: pageTitle,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_sessionError != null) {
      return _buildScaffold(
        title: pageTitle,
        body: _buildInfoState(
          icon: Icons.error_outline_rounded,
          title: 'Gagal membuka sesi chat',
          subtitle: _sessionError!,
        ),
      );
    }

    if (_sessionId == null) {
      return _buildScaffold(
        title: pageTitle,
        body: const SizedBox.shrink(),
      );
    }

    final messagesStream = ref.watch(
      postStreamMessagesProvider(sessionId: _sessionId!),
    );

    return _buildScaffold(
      title: pageTitle,
      subtitle: peerName,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(
              UiSpacing.md,
              UiSpacing.sm,
              UiSpacing.md,
              UiSpacing.xs,
            ),
            padding: const EdgeInsets.all(UiSpacing.sm),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child: Text(
              'Catatan: Ini komunikasi langsung dengan ${_isPasienRole ? "dokter" : "pasien"}, bukan chatbot AI.',
              style: UiTypography.caption.copyWith(
                color: UiPalette.blue600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: messagesStream.when(
              data: (messages) {
                final sortedMessages = [...messages]
                  ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
                final hasUnreadIncoming = sortedMessages.any(
                  (e) => e.senderId != currentUid && !e.isRead,
                );
                if (hasUnreadIncoming) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _markCurrentRoomAsRead();
                  });
                }

                if (sortedMessages.isEmpty) {
                  return _buildInfoState(
                    icon: Icons.chat_bubble_outline_rounded,
                    title: 'Belum ada pesan',
                    subtitle:
                        'Mulai percakapan agar dokter/pasien dapat merespons.',
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(
                    UiSpacing.md,
                    UiSpacing.xs,
                    UiSpacing.md,
                    UiSpacing.md,
                  ),
                  itemCount: sortedMessages.length,
                  itemBuilder: (context, index) {
                    final item = sortedMessages[index];
                    final isMine = item.senderId == currentUid;
                    return _MessageBubble(
                      text: item.message,
                      isMine: isMine,
                      timeText: _timeFormat.format(item.createdAt),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => _buildInfoState(
                icon: Icons.error_outline_rounded,
                title: 'Gagal memuat pesan',
                subtitle: error.toString(),
              ),
            ),
          ),
          _buildComposer(
            enabled: !_isSending,
            onSend: () => _sendMessage(senderId: currentUid),
          ),
        ],
      ),
    );
  }

  Widget _buildScaffold({
    required String title,
    String? subtitle,
    required Widget body,
  }) {
    final shellScope = PasienMainShellScope.maybeOf(context);
    final useMenu =
        widget.embeddedInMainShell && shellScope != null && _isPasienRole;

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [UiPalette.blue50, UiPalette.white],
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  UiSpacing.xs,
                  UiSpacing.xs,
                  UiSpacing.md,
                  UiSpacing.xxs,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: useMenu
                          ? shellScope.openDrawer
                          : () {
                              if (GoRouter.of(context).canPop()) {
                                context.pop();
                              }
                            },
                      icon: Icon(
                        useMenu ? Icons.menu_rounded : Icons.arrow_back_rounded,
                      ),
                      color: UiPalette.slate600,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: UiTypography.title),
                          if (subtitle != null && subtitle.trim().isNotEmpty)
                            Text(
                              subtitle,
                              style: UiTypography.bodySmall.copyWith(
                                color: UiPalette.slate500,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: body),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComposer({
    required bool enabled,
    required VoidCallback onSend,
  }) {
    return Container(
      decoration: const BoxDecoration(
        color: UiPalette.white,
        border: Border(top: BorderSide(color: UiPalette.slate200)),
      ),
      padding: const EdgeInsets.fromLTRB(
        UiSpacing.sm,
        UiSpacing.xs,
        UiSpacing.sm,
        UiSpacing.sm,
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                minLines: 1,
                maxLines: 4,
                enabled: enabled,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                decoration: InputDecoration(
                  hintText: 'Ketik pesan...',
                  hintStyle: UiTypography.bodySmall.copyWith(
                    color: UiPalette.slate500,
                  ),
                  filled: true,
                  fillColor: UiPalette.slate50,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: UiSpacing.sm,
                    vertical: UiSpacing.sm,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: UiPalette.slate200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: UiPalette.slate200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: UiPalette.blue500),
                  ),
                ),
              ),
            ),
            const Gap(UiSpacing.xs),
            SizedBox(
              width: 46,
              height: 46,
              child: FilledButton(
                onPressed: enabled ? onSend : null,
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: UiPalette.blue600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSending
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send_rounded, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(UiSpacing.lg),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(UiSpacing.md),
          decoration: BoxDecoration(
            color: UiPalette.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: UiPalette.slate200),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 30, color: UiPalette.blue600),
              const Gap(UiSpacing.sm),
              Text(
                title,
                style: UiTypography.label.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(UiSpacing.xs),
              Text(
                subtitle,
                style: UiTypography.caption.copyWith(
                  color: UiPalette.slate600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _resolveDokterNameFromPublicProfile(Map<String, dynamic>? data) {
    if (data == null) return 'Dokter Anda';
    final text = (data['fullName'] ??
            data['namaLengkap'] ??
            data['nama'] ??
            data['displayName'] ??
            '')
        .toString()
        .trim();
    return text.isEmpty ? 'Dokter Anda' : text;
  }

  String _resolvePasienName(
    PasienProfileModel? pasienProfile,
    String? titleOverride,
  ) {
    final fromOverride = (titleOverride ?? '').trim();
    if (fromOverride.isNotEmpty) return fromOverride;
    final text = (pasienProfile?.namaLengkap ?? '').trim();
    return text.isEmpty ? 'Pasien' : text;
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.text,
    required this.isMine,
    required this.timeText,
  });

  final String text;
  final bool isMine;
  final String timeText;

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isMine ? UiPalette.blue600 : UiPalette.white;
    final textColor = isMine ? UiPalette.white : UiPalette.slate900;

    return Padding(
      padding: const EdgeInsets.only(bottom: UiSpacing.sm),
      child: Row(
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: UiSpacing.sm,
                vertical: UiSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isMine ? 14 : 6),
                  topRight: Radius.circular(isMine ? 6 : 14),
                  bottomLeft: const Radius.circular(14),
                  bottomRight: const Radius.circular(14),
                ),
                border: isMine
                    ? null
                    : Border.all(color: UiPalette.slate200, width: 1),
              ),
              child: Column(
                crossAxisAlignment:
                    isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: UiTypography.body.copyWith(color: textColor),
                  ),
                  const Gap(4),
                  Text(
                    timeText,
                    style: UiTypography.caption.copyWith(
                      color: isMine ? UiPalette.blue100 : UiPalette.slate500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
