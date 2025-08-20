//#region generated meta
type Inputs = {
    input: any;
};
type Outputs = {
    output: string;
};
//#endregion
import merge from "lodash.merge";
import type { Context } from "@oomol/types/oocana";

export default async function(
    params: Inputs,
    context: Context<Inputs, Outputs>
): Promise<Partial<Outputs> | undefined | void> {
    console.log(merge);
    return {
        "output": "merge"
    }
};
