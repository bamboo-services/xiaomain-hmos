import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';
import { CommonConst } from '../constants/CommonConst';


export default class EntryAbility extends UIAbility {
  onCreate(want, launchParam) {
    // 系统初始化时，创建Ability
    PersistentStorage.PersistProp<Boolean>('userHasLogin', false);
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

    if (AppStorage.Get<Boolean>('userHasLogin')) {
      hilog.info(0x5000, 'XiaoMainLog', '用户已登录，加载主页')
      windowStage.loadContent('pages/HomePage');
    } else {
      hilog.info(0x5000, 'XiaoMainLog', '用户未登录，加载登录页')
      windowStage.loadContent('pages/UserLoginPage');
    }
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
