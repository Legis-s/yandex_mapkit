package com.unact.yandexmapkit;

import android.content.Context;

import androidx.annotation.NonNull;

import com.yandex.mapkit.RequestPoint;
import com.yandex.mapkit.transport.TransportFactory;
import com.yandex.mapkit.transport.masstransit.MasstransitRouter;
import com.yandex.mapkit.transport.masstransit.Session;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class YandexMasstransit implements MethodCallHandler {
    private final MasstransitRouter masstransitRouter;
    private final BinaryMessenger binaryMessenger;
    @SuppressWarnings({"MismatchedQueryAndUpdateOfCollection"})
    private final Map<Integer, YandexMasstransitSession> masstransitSessions = new HashMap<>();

    public YandexMasstransit(Context context, BinaryMessenger messenger) {
        TransportFactory.initialize(context);

        masstransitRouter = TransportFactory.getInstance().createMasstransitRouter();
        binaryMessenger = messenger;
    }

    @Override
    @SuppressWarnings({"SwitchStatementWithTooFewBranches"})
    public void onMethodCall(MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "requestRoutes":
                requestRoutes(call, result);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    @SuppressWarnings({"unchecked", "ConstantConditions"})
    private void requestRoutes(final MethodCall call, final Result result) {
        Map<String, Object> params = (Map<String, Object>) call.arguments;
        Integer sessionId = (Integer) params.get("sessionId");
        List<RequestPoint> points = new ArrayList<>();
        for (Map<String, Object> pointParams : (List<Map<String, Object>>) params.get("points")) {
            points.add(Utils.requestPointFromJson(pointParams));
        }

        Session session = masstransitRouter.requestRoutes(
                points,
                null,
                new YandexMasstransitListener(result)
        );

        YandexMasstransitSession bicycleSession = new YandexMasstransitSession(
                sessionId,
                session,
                binaryMessenger,
                new MasstransitCloseListener()
        );

        masstransitSessions.put(sessionId, bicycleSession);
    }

    public class MasstransitCloseListener {
        public void onClose(int id) {
            masstransitSessions.remove(id);
        }
    }
}
