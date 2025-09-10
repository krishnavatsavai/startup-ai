export interface ApiMonitoringData {
    apiName: string;
    status: 'up' | 'down' | 'unknown';
    responseTime: number; // in milliseconds
    lastChecked: Date;
}

export interface ResourceMonitoringData {
    resourceName: string;
    resourceType: string;
    status: 'running' | 'stopped' | 'degraded';
    metrics: {
        cpuUsage: number; // percentage
        memoryUsage: number; // in MB
        diskUsage: number; // in MB
    };
}

export interface MonitoringResponse {
    apiData: ApiMonitoringData[];
    resourceData: ResourceMonitoringData[];
}