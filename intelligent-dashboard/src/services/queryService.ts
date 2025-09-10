import { sendQueryToAzureFunction } from './azureFunctionService';
import { parseUserQuery } from '../utils/queryParser';

export const executeQuery = async (userInput) => {
    const query = parseUserQuery(userInput);
    try {
        const response = await sendQueryToAzureFunction(query);
        return response;
    } catch (error) {
        console.error('Error executing query:', error);
        throw error;
    }
};

export const validateQuery = (userInput) => {
    // Implement validation logic for user input
    return userInput && userInput.trim().length > 0;
};