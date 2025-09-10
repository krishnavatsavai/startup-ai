import React, { useEffect, useState } from 'react';
import { fetchAzureResources } from '../services/azureFunctionService';
import { ResourceMonitor } from './ResourceMonitor';
import { ApiStatus } from './ApiStatus';
import { QueryPanel } from './QueryPanel';

const Dashboard: React.FC = () => {
    const [resources, setResources] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const loadResources = async () => {
            const data = await fetchAzureResources();
            setResources(data);
            setLoading(false);
        };

        loadResources();
    }, []);

    if (loading) {
        return <div>Loading...</div>;
    }

    return (
        <div className="dashboard">
            <h1>Intelligent Dashboard</h1>
            <QueryPanel />
            <ResourceMonitor resources={resources} />
            <ApiStatus />
        </div>
    );
};

export default Dashboard;