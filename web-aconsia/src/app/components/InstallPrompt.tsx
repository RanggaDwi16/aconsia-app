import { useState } from 'react';
import { Card, CardContent } from './ui/card';
import { Button } from './ui/button';
import { Download, X } from 'lucide-react';
import { usePWA } from '../hooks/usePWA';

export function InstallPrompt() {
  const { isInstallable, installApp } = usePWA();
  const [dismissed, setDismissed] = useState(false);

  if (!isInstallable || dismissed) return null;

  const handleInstall = async () => {
    const installed = await installApp();
    if (installed) {
      setDismissed(true);
    }
  };

  return (
    <div className="fixed bottom-4 left-4 right-4 z-50 md:left-auto md:right-4 md:w-96">
      <Card className="border-blue-200 shadow-xl">
        <CardContent className="p-4">
          <div className="flex items-start gap-3">
            <div className="w-12 h-12 bg-blue-600 rounded-lg flex items-center justify-center flex-shrink-0">
              <Download className="w-6 h-6 text-white" />
            </div>
            
            <div className="flex-1">
              <h3 className="font-semibold text-gray-900 mb-1">
                Install Aplikasi
              </h3>
              <p className="text-sm text-gray-600 mb-3">
                Install aplikasi untuk akses lebih cepat dan bisa digunakan offline!
              </p>
              
              <div className="flex gap-2">
                <Button 
                  size="sm" 
                  onClick={handleInstall}
                  className="bg-blue-600 hover:bg-blue-700 flex-1"
                >
                  Install Sekarang
                </Button>
                <Button 
                  size="sm" 
                  variant="outline"
                  onClick={() => setDismissed(true)}
                >
                  <X className="w-4 h-4" />
                </Button>
              </div>
            </div>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
