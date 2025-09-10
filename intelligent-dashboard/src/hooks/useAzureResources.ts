import { useEffect, useState } from 'react';
import { fetchAzureResources } from '../services/azureFunctionService';
import { AzureResource } from '../types/azure';

const useAzureResources = () => {
    const [resources, setResources] = useState<AzureResource[]>([]);
    const [loading, setLoading] = useState<boolean>(true);
    const [error, setError] = useState<string | null>(null);

    useEffect(() => {
        const getResources = async () => {
            try {
                setLoading(true);
                const data = await fetchAzureResources();
                setResources(data);
            } catch (err) {
                setError(err.message);
            } finally {
                setLoading(false);
            }
        };

        getResources();
    }, []);

    return { resources, loading, error };
};

export default useAzureResources;