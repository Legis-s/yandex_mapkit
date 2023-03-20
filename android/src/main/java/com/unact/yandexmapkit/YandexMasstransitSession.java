package com.unact.yandexmapkit;

import androidx.annotation.NonNull;

import com.yandex.mapkit.transport.masstransit.Session;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class YandexMasstransitSession implements MethodChannel.MethodCallHandler {
    private final int id;
    private final Session session;
    private final MethodChannel methodChannel;
    private final YandexMasstransit.MasstransitCloseListener closeListener;

    public YandexMasstransitSession(
            int id,
            Session session,
            BinaryMessenger messenger,
            YandexMasstransit.MasstransitCloseListener closeListener
    ) {
        this.id = id;
        this.session = session;
        this.closeListener = closeListener;

        methodChannel = new MethodChannel(messenger, "yandex_mapkit/yandex_masstransit_session_" + id);
        methodChannel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "cancel":
                cancel();
                result.success(null);
                break;
            case "retry":
                retry(result);
                break;
            case "close":
                close();
                result.success(null);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    public void cancel() {
        session.cancel();
    }

    public void retry(MethodChannel.Result result) {
        session.retry(new YandexMasstransitListener(result));
    }

    public void close() {
        session.cancel();
        methodChannel.setMethodCallHandler(null);

        closeListener.onClose(id);
    }
}
