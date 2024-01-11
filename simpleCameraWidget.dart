import 'package:camera/camera.dart';

class Video extends StatefulWidget {
  const Video({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _CameraRecordState createState() => _CameraRecordState();
}

class _CameraRecordState extends State<Video> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _controller = CameraController(_cameras![0], ResolutionPreset.max);
      await _controller!.initialize();
      setState(() {});
    }
  }

  Future<void> _startRecording() async {
    if (_controller != null) {
      await _controller!.startVideoRecording();
      setState(() {
        _isRecording = true;
      });
    }
  }

  Future<void> _stopRecording() async {
    if (_controller != null && _isRecording) {
      final file = await _controller!.stopVideoRecording();
      setState(() {
        _isRecording = false;

        FFAppState().video = file.path;
      });
      // ここで動画ファイルを処理
      // 例: print(file.path);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      body: CameraPreview(_controller!),
      floatingActionButton: FloatingActionButton(
        onPressed: _isRecording ? _stopRecording : _startRecording,
        child: Icon(
          _isRecording ? Icons.stop : Icons.start,
          size: 10,
          color: _isRecording ? Colors.red : Colors.white,
        ),
      ),
    );
  }
}
