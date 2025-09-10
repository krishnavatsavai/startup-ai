import React, { useEffect, useState } from 'react';
import { fetchResourceMetrics } from '../services/monitoringService';
import { ResourceMetrics } from '../types/monitoring';

const ResourceMonitor: React.FC = () => {
    const [metrics, setMetrics] = useState<ResourceMetrics[]>([]);
    const [loading, setLoading] = useState<boolean>(true);
    const [error, setError] = useState<string | null>(null);

    useEffect(() => {
        const getMetrics = async () => {
            try {
                const data = await fetchResourceMetrics();
                setMetrics(data);
            } catch (err) {
                setError('Failed to fetch resource metrics');
            } finally {
                setLoading(false);
            }
        };

        getMetrics();
    }, []);

    if (loading) {
        return <div>Loading...</div>;
    }

    if (error) {
        return <div>{error}</div>;
    }

    return (
        <div>
            <h2>Resource Monitor</h2>
            <ul>
                {metrics.map((metric) => (
                    <li key={metric.id}>
                        <strong>{metric.name}</strong>: {metric.status} - {metric.value}
                    </li>
                ))}
            </ul>
        </div>
    );
};

export default ResourceMonitor;