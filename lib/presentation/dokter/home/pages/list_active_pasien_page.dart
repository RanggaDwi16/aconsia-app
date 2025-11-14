import 'package:aconsia_app/presentation/dokter/home/controllers/get_pasien_list_by_dokter_id/fetch_pasien_list_by_dokter_id_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aconsia_app/core/helpers/custom_app_bar.dart';
import 'package:aconsia_app/core/helpers/widgets/custom_search_field.dart';
import 'package:aconsia_app/core/utils/constant/app_colors.dart';
import 'package:aconsia_app/presentation/dokter/home/widgets/list_pasien_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ListActivePasienPage extends ConsumerWidget {
  const ListActivePasienPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    final pasienList =
        ref.watch(fetchPasienListByDokterIdProvider(dokterId: uid ?? ''));

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Kembali',
        centertitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daftar Pasien',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gap(8),
            Text(
              'Pantau daftar pasien aktif dengan mudah.',
              style: TextStyle(
                fontSize: 14,
                color: AppColor.textGrayColor,
              ),
            ),
            Gap(32),
            CustomSearchField(
              hintText: 'Cari Pasien...',
              controller: TextEditingController(),
            ),
            Gap(32),
            pasienList.when(
              data: (data) {
                return ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: data?.length ?? 0,
                  separatorBuilder: (context, index) => Gap(12),
                  itemBuilder: (context, index) {
                    final pasien = data![index];
                    return ListPasienWidget(
                      pasien: pasien,
                    );
                  },
                );
              },
              error: (error, stack) {
                return Center(
                  child: Text('Error: $error'),
                );
              },
              loading: () {
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
