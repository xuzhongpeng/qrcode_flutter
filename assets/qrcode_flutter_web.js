((window) => {
  let html5QrCode;
  let cameraId;
  // build camera view
  window.firstBuild = (width, height) => {
    console.log("build view");
    html5QrCode = new Html5Qrcode(
      "flutter_plugin_camera",
      /* verbose= */ false
    );
    Html5Qrcode.getCameras()
      .then((devices) => {
        if (devices && devices.length) {
          cameraId = devices[0].id;
          // .. use this to start scanning.
          html5QrCode
            .start(
              cameraId,
              {
                fps: 10, // Optional, frame per seconds for qr code scanning
                qrbox: { width: width, height: height }, // Optional, if you want bounded box UI
              },
              (decodedText, decodedResult) => {
                window.onCapture(decodedText);
              }
            )
            .catch((err) => {
              // Start failed, handle it.
              console.error("[qrcode_flutter] start err:" + err);
            });
        }
      })
      .catch((err) => {
        // handle err
      });
  };

  window.rebuild = async (width, height) => {
    await stop();
    html5QrCode
      .start(
        cameraId,
        {
          fps: 10, // Optional, frame per seconds for qr code scanning
          qrbox: { width: width, height: height }, // Optional, if you want bounded box UI
        },
        (decodedText, decodedResult) => {
          window.onCapture(decodedText);
        }
      )
      .catch((err) => {
        // Start failed, handle it.
        console.log("[qrcode_flutter] start err:" + err);
      });
  };

  window.stop = () => {
    return html5QrCode?.stop().catch((err) => {
      console.log("[qrcode_flutter] stop err:" + err);
    });
  };
  window.dispose = () => {
    stop();
    html5QrCode = null;
  };
  window.pause = () => {
    try {
      html5QrCode?.pause();
    } catch (err) {
      console.error("[qrcode_flutter] pause err:" + err);
    }
  };
  window.resume = () => {
    try {
      html5QrCode?.resume();
    } catch (err) {
      console.log("[qrcode_flutter] resume err:" + err);
    }
  };
})(window);
