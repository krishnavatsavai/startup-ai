import { useEffect, useState } from 'react';
import { fetchApiStatus } from '../services/monitoringService';
import { ApiStatus } from '../types/monitoring';

const useApiMonitoring = () => {
    const [apiStatus, setApiStatus] = useState<ApiStatus[]>([]);
    const [loading, setLoading] = useState<boolean>(true);
    const [error, setError] = useState<string | null>(null);

    useEffect(() => {
        const fetchStatus = async () => {
            setLoading(true);
            try {
                const status = await fetchApiStatus();
                setApiStatus(status);
            } catch (err) {
                setError('Failed to fetch API status');
            } finally {
                setLoading(false);
            }
        };

        fetchStatus();
        const interval = setInterval(fetchStatus, 30000); // Refresh every 30 seconds

        return () => clearInterval(interval); // Cleanup on unmount
    }, []);

    return { apiStatus, loading, error };
};

export default useApiMonitoring;