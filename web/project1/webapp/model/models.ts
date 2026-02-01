import JSONModel from "sap/ui/model/json/JSONModel";
import Device from "sap/ui/Device";

/**
 * Create a device model that contains device information
 * @returns {JSONModel} The device model
 */
export function createDeviceModel(): JSONModel {
    const oModel = new JSONModel(Device);
    oModel.setDefaultBindingMode("OneWay");
    return oModel;
}
