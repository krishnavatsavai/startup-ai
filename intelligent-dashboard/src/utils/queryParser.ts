export function parseQuery(query: string): Record<string, any> {
    const parsed: Record<string, any> = {};
    const queryParts = query.split('&');

    queryParts.forEach(part => {
        const [key, value] = part.split('=');
        if (key && value) {
            parsed[decodeURIComponent(key)] = decodeURIComponent(value);
        }
    });

    return parsed;
}

export function validateQuery(parsedQuery: Record<string, any>): boolean {
    // Implement validation logic based on expected query structure
    return Object.keys(parsedQuery).length > 0; // Example validation
}