import { NativeModules } from 'react-native';

type BlinkidVerifyType = {
  multiply(a: number, b: number): Promise<number>;
};

const { BlinkidVerify } = NativeModules;

export default BlinkidVerify as BlinkidVerifyType;
