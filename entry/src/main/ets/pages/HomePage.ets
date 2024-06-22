import router from '@ohos.router'
import { CommonConst } from '../constants/CommonConst'
import { UserLoginPage } from './UserLoginPage';

@Entry
@Component
struct Index {
  build() {
    Column() {
      NavRouter() {

      }

      Tabs({ barPosition: BarPosition.End }) {
        TabContent() {
          UserLoginPage()
        }
        .tabBar('登录')

        TabContent() {
          Text(router.getState().index.toString()).fontSize(30)
        }
        .tabBar('首页')

        TabContent() {
          Column() {
            Text(router.getState().index.toString()).fontSize(30)
            Text('发现的内容').fontSize(30)
          }
        }
        .tabBar('发现')

        TabContent() {
          Text('我的内容').fontSize(30)
        }
        .tabBar("我的")
      }
      .barWidth('100%')
      .padding({ top: 10, bottom: 10 })
    }
    .padding({ top: px2vp(CommonConst.STATUS_BAR_HEIGHT) })
    .width('100%')
    .height('100%');
  }
}