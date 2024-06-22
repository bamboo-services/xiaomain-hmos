import distributedKVStore from '@ohos.data.distributedKVStore';
export let CommonConst = {
  STATUS_BAR_HEIGHT: 0,
  KV_MANAGER_CONFIG: {} as distributedKVStore.KVManagerConfig,
  KV_MANAGER: {} as distributedKVStore.KVManager,
  KV_CONFIG: {
    createIfMissing: true, // 当数据库文件不存在时是否创建数据库，默认创建
    encrypt: false, // 设置数据库文件是否加密，默认不加密
    backup: false, // 设置数据库文件是否备份，默认备份
    kvStoreType: distributedKVStore.KVStoreType.SINGLE_VERSION, // 设置要创建的数据库类型，默认为多设备协同数据库
    securityLevel: distributedKVStore.SecurityLevel.S2 // 设置数据库安全级别
  }
};