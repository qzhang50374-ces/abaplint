import Controller from "sap/ui/core/mvc/Controller";
import JSONModel from "sap/ui/model/json/JSONModel";
import MessageToast from "sap/m/MessageToast";

/**
 * @namespace zzabaplint.controller
 */
export default class Main extends Controller {

    public onInit(): void {
        // Show info message about playground
        MessageToast.show("Loading ABAP Lint Editor with full engine support...");
        
        // Check if playground is running
        this._checkPlaygroundStatus();
    }

    private _checkPlaygroundStatus(): void {
        fetch('http://localhost:8090')
            .then(() => {
                MessageToast.show("Playground server is running on port 8090");
            })
            .catch(() => {
                MessageToast.show("Please start the playground server: cd ../playground && npm run dev", {
                    duration: 5000,
                    width: "30em"
                });
            });
    }

    public onStartPlayground(): void {
        MessageToast.show("Please run in terminal:\ncd C:\\Users\\q_zhang50374\\Documents\\abaplint\\abaplint\\web\\playground\nnpm run dev", {
            duration: 8000,
            width: "35em"
        });
    }
}
