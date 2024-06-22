import hilog from '@ohos.hilog';

@Builder
export function InputLabel(textInfo: string, isNeed: boolean, placeholder, handler: string, inputType: InputType) {
  Column() {
    Flex() {
      Text(textInfo)
        .fontSize(vp2px(11))
        .margin({ right: 5 });
      if (isNeed) {
        Text("*")
          .fontSize(vp2px(11))
          .fontColor(Color.Red);
      }
    }.margin({ bottom: vp2px(5) })

    TextInput({ placeholder: placeholder, text: AppStorage.Get<string>(handler) })
      .height(vp2px(30))
      .type(inputType)
      .borderRadius(vp2px(11))
      .onChange((text) => {
        changeHandler(text, handler)
      });
  }
}

function changeHandler(text, handler: string) {
  AppStorage.SetOrCreate(handler, text);
  hilog.info(0x5000, "XiaoMainLog", "修改内容 %{public}s, 变量获取 %{public}s", text, AppStorage.Get<string>(handler))
}