import { useEffect, useRef, useState } from "react";
import { usePWA } from '../hooks/usePWA';
import { WifiOff, Wifi } from 'lucide-react';
import { motion, AnimatePresence } from 'motion/react';

export function OfflineIndicator() {
  const { isOnline } = usePWA();
  const [showOnlineNotice, setShowOnlineNotice] = useState(false);
  const isFirstRenderRef = useRef(true);
  const previousOnlineRef = useRef(isOnline);

  useEffect(() => {
    const wasOnline = previousOnlineRef.current;
    previousOnlineRef.current = isOnline;

    // Skip initial paint to avoid showing "Kembali online!" every page load.
    if (isFirstRenderRef.current) {
      isFirstRenderRef.current = false;
      return;
    }

    if (!wasOnline && isOnline) {
      setShowOnlineNotice(true);
      const timer = window.setTimeout(() => {
        setShowOnlineNotice(false);
      }, 2500);

      return () => window.clearTimeout(timer);
    }

    if (!isOnline) {
      setShowOnlineNotice(false);
    }
  }, [isOnline]);

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
      
      {showOnlineNotice && (
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
