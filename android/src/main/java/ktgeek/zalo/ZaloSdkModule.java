package ktgeek.zalo;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.Promise;

import com.zing.zalo.zalosdk.oauth.FeedData;
import com.zing.zalo.zalosdk.oauth.OAuthCompleteListener;
import com.zing.zalo.zalosdk.oauth.ValidateOAuthCodeCallback;
import com.zing.zalo.zalosdk.oauth.ZaloOpenAPICallback;
import com.zing.zalo.zalosdk.oauth.ZaloPluginCallback;
import com.zing.zalo.zalosdk.oauth.ZaloSDK;
import com.zing.zalo.zalosdk.oauth.OauthResponse;
import com.zing.zalo.zalosdk.oauth.LoginVia;
import com.zing.zalo.zalosdk.oauth.OpenAPIService;

import org.json.JSONObject;

public class ZaloSdkModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;

    public ZaloSdkModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "ZaloSdk";
    }

    //region Authentication

    @ReactMethod
    public void login(final Promise promise) {
        ZaloSDK.Instance.unauthenticate();
        ZaloSDK.Instance.authenticate(this.reactContext.getCurrentActivity(), LoginVia.APP_OR_WEB,
                new OAuthCompleteListener() {
                    @Override
                    public void onAuthenError(int errorCode, String message) {
                        final String code = errorCode + "";
                        promise.reject(code, message);
                    }

                    @Override
                    public void onGetOAuthComplete(OauthResponse response) {
                        super.onGetOAuthComplete(response);
                        promise.resolve(response.getOauthCode());
                    }
                });
    }

    @ReactMethod
    public void isAuthenticated(final Promise promise) {
        ZaloSDK.Instance.isAuthenticate(new ValidateOAuthCodeCallback() {
            @Override
            public void onValidateComplete(boolean validated, int errorCode, long userId, String oauthCode) {
                if (validated) {
                    promise.resolve(true);
                } else {
                    promise.reject(errorCode + "", "Oauth code was invalidated!");
                }
            }
        });
    }

    @ReactMethod
    public void logout() {
        ZaloSDK.Instance.unauthenticate();
    }

    //endregion

    //region Interact with Zalo app

    @ReactMethod
    public void sendMessageInZalo(final String message, final String appName, final String link, final Promise promise) {
        FeedData feed = new FeedData();
        feed.setMsg(message);
        feed.setAppName(appName);
        feed.setLink(link);
        OpenAPIService.getInstance().shareMessage(this.reactContext.getCurrentActivity(), feed, new ZaloPluginCallback() {
            @Override
            public void onResult(boolean isSuccess, int errorCode, String msg, String data) {
                if (isSuccess) {
                    promise.resolve(null);
                } else {
                    promise.reject(errorCode + "", msg);
                }
            }
        });
    }

    @ReactMethod
    public void shareFeedInZalo(final String message, final String appName, final String link, final Promise promise) {
        FeedData feed = new FeedData();
        feed.setMsg(message);
        feed.setAppName(appName);
        feed.setLink(link);
        OpenAPIService.getInstance().shareFeed(this.reactContext.getCurrentActivity(), feed, new ZaloPluginCallback() {
            @Override
            public void onResult(boolean isSuccess, int errorCode, String msg, String data) {
                if (isSuccess) {
                    promise.resolve(null);
                } else {
                    promise.reject(errorCode + "", msg);
                }
            }
        });
    }

    //endregion

    //region Open APIs

    // TODO: Port all APIs

    //endregion

    @ReactMethod
    public void getProfile(final Promise promise) {
        final String[] Fields = { "id", "birthday", "gender", "picture", "name" };
        ZaloSDK.Instance.getProfile(this.reactContext.getCurrentActivity(), new ZaloOpenAPICallback() {
            @Override
            public void onResult(JSONObject data) {
                try {
                    WritableMap user = UtilService.convertJsonToMap(data);
                    promise.resolve(user);
                } catch (Exception ex) {
                    String message = ex.getMessage();
                    promise.reject("Get profile error", message, ex);
                }
            }
        }, Fields);
    }


}
