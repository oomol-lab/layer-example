//#region generated meta
/**
 * @typedef {{
 * }} Inputs;
 * @typedef {{
 *   output: string;
 * }} Outputs;
 */
//#endregion

import isplainobject from "lodash.isplainobject";


/**
 * @import { Context } from "@oomol/types/oocana"
 * @param {Inputs} params
 * @param {Context<Inputs, Outputs>} context
 * @returns {Promise<Partial<Outputs> | undefined | void>}
 */
export default async function (params, context) {

    console.log(isplainobject)

    return { output: "javascript" };
}
