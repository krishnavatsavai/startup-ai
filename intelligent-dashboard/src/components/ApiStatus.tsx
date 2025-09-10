import React, { useEffect, useState } from 'react';
import { getApiStatus } from '../services/monitoringService';

const ApiStatus: React.FC = () => {
    const [apiStatus, setApiStatus] = useState([]);

    useEffect(() => {
        const fetchApiStatus = async () => {
            const status = await getApiStatus();
            setApiStatus(status);
        };

        fetchApiStatus();
        const interval = setInterval(fetchApiStatus, 5000); // Refresh every 5 seconds

        return () => clearInterval(interval); // Cleanup on unmount
    }, []);

    return (
        <div>
            <h2>API Status</h2>
            <ul>
                {apiStatus.map((api, index) => (
                    <li key={index}>
                        <strong>{api.name}</strong>: {api.status}
                    </li>
                ))}
            </ul>
        </div>
    );
};

export default ApiStatus;