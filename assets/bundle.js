console.log("yes");

// console.log(Html5QrcodeScanner)

// let html5QrcodeScanner = new Html5QrcodeScanner(
//   "flutter_plugin_camera",
//   { fps: 10, qrbox: { width: 250, height: 250 } },
//   /* verbose= */ false
// );
// function onScanSuccess(decodedText, decodedResult) {
//   // handle the scanned code as you like, for example:
//   console.log(`Code matched = ${decodedText}`, decodedResult);
// }

// function onScanFailure(error) {
//   // handle scan failure, usually better to ignore and keep scanning.
//   // for example:
//   console.warn(`Code scan error = ${error}`);
// }
// html5QrcodeScanner.render(onScanSuccess, onScanFailure);
((window) => {
  let html5QrCode;
  // build camera view
  console.log(window);
  window.firstBuild = (width, height) => {
    console.log("build view");
    html5QrCode = new Html5Qrcode(
      "flutter_plugin_camera",
      /* verbose= */ false
    );
    Html5Qrcode.getCameras()
      .then((devices) => {
        console.log(devices);
        if (devices && devices.length) {
          var cameraId = devices[0].id;
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
              console.log("err" + err);
            });
        }
      })
      .catch((err) => {
        // handle err
      });
  };

  window.rebuild = () => {
    stop();
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
        console.log("err" + err);
      });
  };

  window.stop = () => {
    html5QrCode
      ?.stop()
      .then((ignore) => {
        // QR Code scanning is stopped.
      })
      .catch((err) => {
        // Stop failed, handle it.
      });
  };
  window.dispose = () => {
    stop();
    html5QrCode = null;
  };
  window.pause = () => {
    html5QrCode?.pause();
  };
  window.resume = () => {
    html5QrCode
      ?.resume()
      .then((ignore) => {
        // QR Code scanning is stopped.
      })
      .catch((err) => {
        // Stop failed, handle it.
      });
  };
})(window);
