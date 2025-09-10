import { useEffect, useState } from 'react';
import { fetchApiStatus, fetchResourceStatus } from '../services/azureFunctionService';
import { ApiStatusData, ResourceStatusData } from '../types/monitoring';

export const useMonitoring = () => {
    const [apiStatus, setApiStatus] = useState<ApiStatusData[]>([]);
    const [resourceStatus, setResourceStatus] = useState<ResourceStatusData[]>([]);
    const [loading, setLoading] = useState<boolean>(true);
    const [error, setError] = useState<string | null>(null);

    useEffect(() => {
        const fetchData = async () => {
            setLoading(true);
            try {
                const apiData = await fetchApiStatus();
                const resourceData = await fetchResourceStatus();
                setApiStatus(apiData);
                setResourceStatus(resourceData);
            } catch (err) {
                setError('Failed to fetch monitoring data');
            } finally {
                setLoading(false);
            }
        };

        fetchData();
    }, []);

    return { apiStatus, resourceStatus, loading, error };
};