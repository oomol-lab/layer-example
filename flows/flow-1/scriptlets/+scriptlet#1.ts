//#region generated meta
type Inputs = {
    output: any;
};
type Outputs = {
};
//#endregion

import type { Context } from "@oomol/types/oocana";
import isplainObject from "lodash.isplainobject"

export default async function(
    params: Inputs,
    context: Context<Inputs, Outputs>
): Promise<Partial<Outputs> | undefined | void> {

    const b = isplainObject(context);
    console.log("isplainObject:", b)
};
