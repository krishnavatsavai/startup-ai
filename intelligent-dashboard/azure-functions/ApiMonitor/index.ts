import { AzureFunction, Context, HttpRequest } from "@azure/functions";
import axios from "axios";

const apiMonitor: AzureFunction = async (context: Context, req: HttpRequest): Promise<void> => {
    const apiUrl = req.query.apiUrl;

    if (!apiUrl) {
        context.res = {
            status: 400,
            body: "Please provide an API URL to monitor."
        };
        return;
    }

    try {
        const response = await axios.get(apiUrl);
        context.res = {
            status: 200,
            body: {
                status: response.status,
                data: response.data,
                headers: response.headers
            }
        };
    } catch (error) {
        context.res = {
            status: error.response ? error.response.status : 500,
            body: {
                message: "Error monitoring API",
                error: error.message
            }
        };
    }
};

export default apiMonitor;