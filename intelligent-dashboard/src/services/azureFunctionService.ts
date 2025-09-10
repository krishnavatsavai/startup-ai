import axios from 'axios';

const AZURE_FUNCTIONS_BASE_URL = process.env.REACT_APP_AZURE_FUNCTIONS_BASE_URL;

export const queryAzureResources = async (query) => {
    try {
        const response = await axios.post(`${AZURE_FUNCTIONS_BASE_URL}/ResourceQuery`, { query });
        return response.data;
    } catch (error) {
        console.error('Error querying Azure resources:', error);
        throw error;
    }
};

export const monitorApiStatus = async (apiEndpoint) => {
    try {
        const response = await axios.get(`${AZURE_FUNCTIONS_BASE_URL}/ApiMonitor`, { params: { endpoint: apiEndpoint } });
        return response.data;
    } catch (error) {
        console.error('Error monitoring API status:', error);
        throw error;
    }
};