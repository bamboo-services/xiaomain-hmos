import { CommonConst } from '../constants/CommonConst'
import { InputLabel } from '../components/LoginComponent';
import hilog from '@ohos.hilog';

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
          InputLabel("服务器", true, "https://www.x-lf.com", 'serverHost', InputType.Normal)
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
            .onClick(() => {
              // 错误返回
              if (!checkInputHasCorrect()) {
                this.dialogController.open()
              } else {
                AppStorage.Delete('loginErrorMessage');
              }
              // 提交登录
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
  if (AppStorage.Get<string>('serverHost') == undefined || AppStorage.Get<string>('serverHost') === "") {
    AppStorage.SetOrCreate<string>('loginErrorMessage', "服务器地址不能为空")
    hilog.info(0x5000, "XiaoMainLog", "%{public}s", AppStorage.Get<string>('loginErrorMessage'));
    return false;
  }
  return true;
}