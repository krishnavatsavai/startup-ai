export interface DashboardData {
    totalResources: number;
    totalAPIs: number;
    resourceStatus: ResourceStatus[];
    apiStatus: ApiStatus[];
}

export interface ResourceStatus {
    id: string;
    name: string;
    type: string;
    status: 'Running' | 'Stopped' | 'Error';
    metrics: ResourceMetrics;
}

export interface ResourceMetrics {
    cpuUsage: number;
    memoryUsage: number;
    diskUsage: number;
}

export interface ApiStatus {
    id: string;
    name: string;
    endpoint: string;
    status: 'Healthy' | 'Degraded' | 'Down';
    responseTime: number;
}