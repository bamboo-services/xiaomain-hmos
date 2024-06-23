import UIAbility from '@ohos.app.ability.UIAbility';
import distributedKVStore from '@ohos.data.distributedKVStore';
import hilog from '@ohos.hilog';
import window from '@ohos.window';
import { CommonConst } from '../constants/CommonConst';

export default class EntryAbility extends UIAbility {
  onCreate(want, launchParam) {
    // 系统初始化时，创建Ability
    PersistentStorage.PersistProp<Boolean>('userHasLogin', false);
    CommonConst.KV_MANAGER_CONFIG = {
      context: this.context,
      bundleName: 'com.xlf.xiaomain'
    };
    try {
      // 创建KVManager实例
      CommonConst.KV_MANAGER = distributedKVStore.createKVManager(CommonConst.KV_MANAGER_CONFIG)
      console.info('Succeeded in creating KVManager.');
      // 继续创建获取数据库
    } catch (e) {
      console.error(`Failed to create KVManager. Code:${e.code},message:${e.message}`);
    }
    hilog.info(0x5000, 'XiaoMainLog', '%{public}s', 'Ability 已创建');
  }

  onDestroy() {
    hilog.info(0x5000, 'XiaoMainLog', '%{public}s', 'Ability 已销毁');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // 创建主窗口，为此功能设置主页面
    hilog.info(0x5000, 'XiaoMainLog', '%{public}s', 'Ability 在窗口阶段创建');

    windowStage.getMainWindow((_, windowClass) => {
      hilog.info(0x5000, 'XiaoMainLog', '处理全屏窗口对象');
      windowClass.setWindowLayoutFullScreen(true);
      const statusBarHeight = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM).topRect.height
      CommonConst.STATUS_BAR_HEIGHT = statusBarHeight;
    })
    // 变量赋予操作
    CommonConst.KV_MANAGER.getKVStore('globalStorage', CommonConst.KV_CONFIG, (_, kvStore) => {
      const store = kvStore as distributedKVStore.SingleKVStore;
      try {
        store.get('serverUrl', (_, value) => {
          AppStorage.SetOrCreate<string>('serverUrl', value as string);
          hilog.info(0x5000, 'XiaoMainLog', '获取服务器地址：%{public}s', AppStorage.Get<string>('serverUrl'));
        });
      } catch (e) {
        console.error(`Failed to get serverUrl. Code:${e.code},message:${e.message}`);
      }

      try {
        store.get('userToken', (_, value) => {
          AppStorage.SetOrCreate<string>('userToken', value as string);
          hilog.info(0x5000, 'XiaoMainLog', '获取token：%{public}s', AppStorage.Get<string>('userToken'));
        });
        store.get('userUuid', (_, value) => {
          AppStorage.SetOrCreate<string>('userUuid', value as string);
          hilog.info(0x5000, 'XiaoMainLog', '获取用户uuid：%{public}s', AppStorage.Get<string>('userUuid'));
        })
      } catch (e) {
        console.error(`Failed to get token. Code:${e.code},message:${e.message}`);
      }
    });

    setTimeout(() => {
      // 地址跳转
      if (AppStorage.Get<Boolean>('userToken')) {
        hilog.info(0x5000, 'XiaoMainLog', '用户已登录，加载主页')
        windowStage.loadContent('pages/HomePage');
      } else {
        hilog.info(0x5000, 'XiaoMainLog', '用户未登录，加载登录页')
        windowStage.loadContent('pages/UserLoginPage');
      }
    }, 100);
  }

  onWindowStageDestroy() {
    // 主窗口被破坏，发布UI相关资源
    hilog.info(0x5000, 'XiaoMainLog', '%{public}s', 'Ability 在窗口阶段销毁');
  }

  onForeground() {
    // 能力已经浮出水面
    hilog.info(0x5000, 'XiaoMainLog', '%{public}s', 'Ability 在前台中');
  }

  onBackground() {
    // 能力有回矫情况
    hilog.info(0x5000, 'XiaoMainLog', '%{public}s', 'Ability 在后台中');
  }
}
