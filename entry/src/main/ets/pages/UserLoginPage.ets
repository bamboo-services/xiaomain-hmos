import { CommonConst } from '../constants/CommonConst'
import { InputLabel } from '../components/LoginComponent';
import hilog from '@ohos.hilog';
import http from '@ohos.net.http';
import distributedKVStore from '@ohos.data.distributedKVStore';

@Entry
@Component
export struct UserLoginPage {
  dialogController: CustomDialogController = new CustomDialogController({
    builder: ErrorDialog({}),
    offset: { dx: 0, dy: vp2px(-20) },
    alignment: DialogAlignment.Bottom,
    autoCancel: false,
    customStyle: true
  })

  build() {
    Column() {
      GridRow({ gutter: vp2px(15) }) {
        GridCol({ span: 12 }) {
          Text('筱主页终端').fontSize(vp2px(25)).fontWeight(FontWeight.Bold);
        }.padding({ bottom: 50 })

        GridCol({ span: 12 }) {
          InputLabel("服务器", true, 'http://www.x-lf.com', 'serverUrl', InputType.Normal)
        }

        GridCol({ span: 12 }) {
          InputLabel("用户名", true, "xiao_lfeng", 'username', InputType.Normal)
        }

        GridCol({ span: 12 }) {
          InputLabel("密码", true, "", 'password', InputType.Password)
        }

        GridCol({ span: 12 }) {
          Button('登录')
            .fontSize(vp2px(11))
            .type(ButtonType.Normal)
            .borderRadius(vp2px(11))
            .padding({ bottom: vp2px(8), top: vp2px(8), left: vp2px(25), right: vp2px(25) })
            .onClick(async () => {
              // 错误返回
              if (!checkInputHasCorrect()) {
                this.dialogController.open()
              } else {
                // 提交登录
                if (await checkLinkAbleUse()) {
                  // 地址持久化存储
                  CommonConst.KV_MANAGER.getKVStore('globalStorage', CommonConst.KV_CONFIG, (_, kvStore) => {
                    const store = kvStore as distributedKVStore.SingleKVStore;
                    store.put('serverUrl', AppStorage.Get<string>('serverUrl'), (err) => {
                      if (err) {
                        hilog.error(0x5000, "XiaoMainLog", "持久化存储失败 %{public}s", err.message);
                      } else {
                        hilog.info(0x5000, "XiaoMainLog", "持久化存储成功 %{public}s", "serverUrl");
                      }
                    });
                  })
                  hilog.info(0x5000, "XiaoMainLog", "登录成功");
                  AppStorage.Delete('loginErrorMessage');
                  submitLogin();
                } else {
                  setTimeout(() => {
                    this.dialogController.open()
                  }, 100);
                }
              }
            })
        }.margin({ top: 30 })
      }
    }
    .margin({ left: vp2px(20), right: vp2px(20) })
    .padding({ top: px2vp(CommonConst.STATUS_BAR_HEIGHT) })
    .justifyContent(FlexAlign.Center)
    .height('100%');
  }
}

@CustomDialog
struct ErrorDialog {
  controller: CustomDialogController

  build() {
    Column({ space: vp2px(11) }) {
      Flex() {
        Text('错误')
          .fontSize(vp2px(13))
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Black);
      }

      Flex() {
        Text(AppStorage.Get<string>('loginErrorMessage'))
          .fontSize(vp2px(11))
          .fontColor(Color.Black);
      }

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('确认')
          .width('100%')
          .fontSize(vp2px(11))
          .type(ButtonType.Normal)
          .borderRadius(vp2px(11))
          .backgroundColor(Color.Transparent)
          .padding(vp2px(5))
          .fontColor(Color.Gray)
          .onClick(() => {
            this.controller.close()
          });
      }.margin({ top: vp2px(5) })
    }
    .backgroundColor(Color.White)
    .margin({ left: vp2px(20), right: vp2px(20) })
    .padding(vp2px(11))
    .borderRadius(vp2px(11))
  }
}

function checkInputHasCorrect(): boolean {
  // 检查服务器是否输入
  if (AppStorage.Get<string>('serverUrl') == undefined || AppStorage.Get<string>('serverUrl') === "") {
    AppStorage.SetOrCreate<string>('loginErrorMessage', "服务器地址不能为空")
    hilog.info(0x5000, "XiaoMainLog", "%{public}s", AppStorage.Get<string>('loginErrorMessage'));
    return false;
  }
  // 网站正则表达式检查
  const reg = new RegExp("[a-zA-z]+://[^\s]*");
  if (!reg.test(AppStorage.Get<string>('serverUrl'))) {
    AppStorage.SetOrCreate<string>('loginErrorMessage', "服务器地址格式错误")
    hilog.info(0x5000, "XiaoMainLog", "%{public}s", AppStorage.Get<string>('loginErrorMessage'));
    return false;
  }
  // 检查用户名输入
  if (AppStorage.Get<string>('username') == undefined || AppStorage.Get<string>('username') === "") {
    AppStorage.SetOrCreate<string>('loginErrorMessage', "用户名不能为空")
    hilog.info(0x5000, "XiaoMainLog", "%{public}s", AppStorage.Get<string>('loginErrorMessage'));
    return false;
  }
  // 检查密码输入
  if (AppStorage.Get<string>('password') == undefined || AppStorage.Get<string>('password') === "") {
    AppStorage.SetOrCreate<string>('loginErrorMessage', "密码不能为空")
    hilog.info(0x5000, "XiaoMainLog", "%{public}s", AppStorage.Get<string>('loginErrorMessage'));
    return false;
  }
  return true;
}

async function checkLinkAbleUse(): Promise<boolean> {
  // 发送请求
  const httpRequest = http.createHttp();
  await httpRequest.request(AppStorage.Get<string>('serverUrl') + '/api/v1/info', {
    method: http.RequestMethod.GET,
    header: {
      'Content-Type': 'application/json',
    },
    expectDataType: http.HttpDataType.STRING,
    usingCache: false,
  }).then((response) => {
    hilog.info(0x5000, "XiaoMainLog", "Response: %{public}s", response.result.toString());
    const getJson = JSON.parse(response.result.toString());
    hilog.info(0x5000, "XiaoMainLog", "%{public}s", getJson);
    if (getJson.output !== "Success") {
      AppStorage.SetOrCreate<string>('loginErrorMessage', getJson.output);
      hilog.info(0x5000, "XiaoMainLog", "%{public}s", AppStorage.Get<string>('loginErrorMessage'));
      return false;
    }
  }).catch((error) => {
    AppStorage.SetOrCreate<string>('loginErrorMessage', "服务器连接失败，请检查服务器地址是否正确");
    hilog.info(0x5000, "XiaoMainLog", "%{public}s", AppStorage.Get<string>('loginErrorMessage'));
    hilog.warn(0x5000, "XiaoMainLog", "Error: %{public}s", error.message);
  });
  if (AppStorage.Get<string>('loginErrorMessage') !== undefined) {
    if (AppStorage.Get<string>('loginErrorMessage') === "") {
      hilog.info(0x5000, "XiaoMainLog", "未知错误");
    }
    return false;
  } else {
    return true;
  }
}

function submitLogin() {

}