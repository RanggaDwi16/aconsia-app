import { usePWA } from '../hooks/usePWA';
import { WifiOff, Wifi } from 'lucide-react';
import { motion, AnimatePresence } from 'motion/react';

export function OfflineIndicator() {
  const { isOnline } = usePWA();

  return (
    <AnimatePresence>
      {!isOnline && (
        <motion.div
          initial={{ y: -100 }}
          animate={{ y: 0 }}
          exit={{ y: -100 }}
          className="fixed top-0 left-0 right-0 z-50 bg-yellow-500 text-white py-2 px-4 text-center text-sm font-medium shadow-lg"
        >
          <div className="flex items-center justify-center gap-2">
            <WifiOff className="w-4 h-4" />
            <span>Anda sedang offline - Beberapa fitur mungkin tidak tersedia</span>
          </div>
        </motion.div>
      )}
      
      {isOnline && (
        <motion.div
          initial={{ y: -100 }}
          animate={{ y: 0 }}
          exit={{ y: -100 }}
          className="fixed top-0 left-0 right-0 z-50 bg-green-500 text-white py-2 px-4 text-center text-sm font-medium shadow-lg"
          transition={{ delay: 0.5 }}
        >
          <div className="flex items-center justify-center gap-2">
            <Wifi className="w-4 h-4" />
            <span>Kembali online!</span>
          </div>
        </motion.div>
      )}
    </AnimatePresence>
  );
}
