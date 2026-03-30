import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Main Content
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo & Title
                      _buildLogoSection(),
                      
                      const SizedBox(height: 48),
                      
                      // Description
                      _buildDescription(),
                      
                      const SizedBox(height: 40),
                      
                      // Buttons
                      _buildButtons(context),
                      
                      const SizedBox(height: 40),
                      
                      // Help Link
                      _buildHelpLink(context),
                    ],
                  ),
                ),
              ),
            ),
            
            // Footer
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      children: [
        // Logo Circle - Clean & Simple
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF2563EB), Color(0xFF059669)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Text(
                  'A',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 32),
        
        // Title - Bold & Clean
        const Text(
          'ACONSIA',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A), // slate-900
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Text(
            'Platform Edukasi Anestesi Digital',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Menghubungkan dokter dan pasien untuk memahami prosedur anestesi dengan lebih baik sebelum operasi',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B), // slate-500
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        // Dokter Button - Solid Emerald
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/doctor-login'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF059669), // emerald-600
              foregroundColor: Colors.white,
            ),
            child: const Text('Masuk sebagai Dokter'),
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Pasien Button - Outline
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => Navigator.pushNamed(context, '/patient-login'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF334155), // slate-700
              side: const BorderSide(
                color: Color(0xFFCBD5E1), // slate-300
                width: 2,
              ),
            ).copyWith(
              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.hovered)) {
                    return const Color(0xFF2563EB).withOpacity(0.05);
                  }
                  return null;
                },
              ),
            ),
            child: const Text('Masuk sebagai Pasien'),
          ),
        ),
      ],
    );
  }

  Widget _buildHelpLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Butuh Bantuan? ',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF64748B), // slate-500
          ),
        ),
        TextButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Tutorial'),
                content: const Text(
                  'Fitur Tutorial sedang dalam pengembangan.\n\nSilakan hubungi administrator untuk bantuan.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Tutorial',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2563EB), // blue-600
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFFE2E8F0), width: 1), // slate-200
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        children: [
          // Security Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shield_outlined,
                size: 20,
                color: const Color(0xFF2563EB), // blue-600
              ),
              const SizedBox(width: 8),
              const Text(
                'Medical Grade Security',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF334155), // slate-700
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Copyright
          const Text(
            '© 2025 ACONSIA - Sistem Informasi untuk Edukasi Pasien',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF94A3B8), // slate-400
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Security Notice
          const Text(
            '🔒 Keamanan Data Pasien Terjamin',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B), // slate-500
            ),
          ),
        ],
      ),
    );
  }
}
