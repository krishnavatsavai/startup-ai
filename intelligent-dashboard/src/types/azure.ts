export interface AzureResource {
    id: string;
    name: string;
    type: string;
    location: string;
    properties: Record<string, any>;
}

export interface AzureFunctionResponse<T> {
    status: string;
    data: T;
    error?: string;
}

export interface ApiStatus {
    apiName: string;
    status: 'up' | 'down' | 'unknown';
    responseTime: number; // in milliseconds
    lastChecked: Date;
}

export interface ResourceQuery {
    resourceId: string;
    queryParameters: Record<string, any>;
}