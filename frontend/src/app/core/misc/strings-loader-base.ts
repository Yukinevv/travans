import { CommonStrings } from './common-strings';

export interface StringsLoaderBase {
  get commonStrings(): CommonStrings;
}
