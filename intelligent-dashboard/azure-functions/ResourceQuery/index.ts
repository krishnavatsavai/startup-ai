import { AzureFunction, Context, HttpRequest } from "@azure/functions";
import { queryAzureResources } from "../../src/services/azureFunctionService";

const resourceQuery: AzureFunction = async (context: Context, req: HttpRequest): Promise<void> => {
    const query = req.query.query;

    if (!query) {
        context.res = {
            status: 400,
            body: "Please provide a query parameter."
        };
        return;
    }

    try {
        const resources = await queryAzureResources(query);
        context.res = {
            status: 200,
            body: resources
        };
    } catch (error) {
        context.res = {
            status: 500,
            body: "Error querying resources: " + error.message
        };
    }
};

export default resourceQuery;