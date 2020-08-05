package asia.yesdoctor.flutter_kbzpay;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import com.kbzbank.payment.KBZPay;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;

/** FlutterKbzpayPlugin */
public class FlutterKbzpayPlugin implements MethodCallHandler {

  private static EventChannel.EventSink sink;

  private final Context context;

  private static final String METHOD_INIT = "init";
  private static final String METHOD_START_PAY = "startPay";

  private String mOrderInfo;
  private String mMerchantCode = ""; // Please don't save merchant code in app. This just a demo.
  private String mAppId = ""; // Please don't save appId in app. This just a demo.
  private String mSignKey = "";// Please don't save sign key in app. This just a demo.
  private String mNonceStr = "";
  private String mSign = "";
  private String mSignType = "SHA256";
  private String mPrepayId = "";

  public static void registerWith(Registrar registrar) {
    final MethodChannel methodChannel = new MethodChannel(registrar.messenger(), "flutter_kbzpay");
    final EventChannel eventchannel = new EventChannel(registrar.messenger(), "flutter_kbzpay/pay_status");
    methodChannel.setMethodCallHandler(new FlutterKbzpayPlugin(registrar.activeContext()));
    eventchannel.setStreamHandler(new EventChannel.StreamHandler() {
      @Override
      public void onListen(Object o, EventChannel.EventSink eventSink) {
        SetSink(eventSink);
      }

      @Override
      public void onCancel(Object o) {

      }
    });
  }

  public static void SetSink(EventChannel.EventSink eventSink) {
    sink = eventSink;
  }

  public static void sendPayStatus(int status, String orderId) {
    HashMap<String, Object> map = new HashMap();
    map.put("status", status);
    map.put("orderId", orderId);
    sink.success(map);
  }

  public FlutterKbzpayPlugin(Context context) {
    this.context = context;
  }

  @Override
  public void onMethodCall(MethodCall call, final Result result) {
    if (call.method.equals(METHOD_START_PAY)) {
      startPay(call, result);
    } else {
      result.notImplemented();
    }
  }

  private void startPay(MethodCall call, Result result) {
    HashMap<String, Object> map = call.arguments();
    try {
      JSONObject params = new JSONObject(map);
      Log.v("createPay", params.toString());
      if (params.has("prepayId") && params.has("merchantCode") && params.has("appId") && params.has("appKey")) {

        mAppId = params.getString("appId");
        mSignKey = params.getString("appKey");
        mMerchantCode = params.getString("merchantCode");
        mNonceStr = createRandomStr();
        mPrepayId = params.getString("prepayId");
        buildOrderInfo();
        Log.d("KBZPay", "success!");
        KBZPay.startPay((Activity) this.context, mOrderInfo, mSign, mSignType);

        result.success("payStatus " + 0);
      } else {
        result.error("parameter error", "parameter error", null);
      }
    } catch (JSONException e) {
      e.printStackTrace();
      return;
    }
  }

  /**
   * order info please create in server side. this function just a demo.
   */
  private void buildOrderInfo() {
    String timestamp = createTimestamp();

    mOrderInfo = "appid=" + mAppId +
            "&merch_code=" + mMerchantCode +
            "&nonce_str=" + mNonceStr +
            "&prepay_id=" + mPrepayId +
            "&timestamp=" + timestamp;
    mSign = SHA.getSHA256Str(mOrderInfo + "&key=" + mSignKey);
  }

  private String createRandomStr() {
    Random random = new Random();
    return Long.toString(Math.abs(random.nextLong()));
  }

  private String createTimestamp() {
    java.util.Calendar cal = java.util.Calendar.getInstance();
    double time = cal.getTimeInMillis() / 1000;
    Double d = Double.valueOf(time);
    return Integer.toString(d.intValue());
  }
}
