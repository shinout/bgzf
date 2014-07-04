#include <node.h>
#include <nan.h>

#include <zlib.h>
#include <cstring>
#include <cstdlib>
NAN_METHOD(InflateRawSync);


using v8::FunctionTemplate;
using v8::Handle;
using v8::Object;
using v8::String;
using v8::Number;
using v8::Local;
using node::Buffer;

#define ERR(msg) v8::ThrowException(v8::Exception::Error(String::New(msg)));

// function to export
NAN_METHOD(InflateRawSync) {
  NanScope();

  if(args.Length() < 2 || !Buffer::HasInstance(args[0]) || !Buffer::HasInstance(args[1])) {
    return ERR("arguments must be Buffer objects")
  }
  Local<Object> input  = args[0]->ToObject();
  Local<Object> result = args[1]->ToObject();
  Bytef* in_buf  = (Bytef*)Buffer::Data(input);
  Bytef* res_buf = (Bytef*)Buffer::Data(result);
  int in_len  = Buffer::Length(input);
  int res_len = Buffer::Length(result);

  z_stream strm;
  strm.zalloc = Z_NULL;
  strm.zfree = Z_NULL;
  strm.opaque = Z_NULL;
  strm.avail_in = 0;
  strm.next_in = Z_NULL;

  int ret = inflateInit2(&strm, -15);
  if (ret != Z_OK)
    return ERR("could not initialize the data");

  strm.avail_in = in_len;
  strm.next_in = in_buf;
  strm.avail_out = res_len;
  strm.next_out = res_buf;

  ret = inflate(&strm, Z_NO_FLUSH);
  if (ret != Z_STREAM_END && ret != Z_OK)
    return ERR("Invalid format");

  (void)inflateEnd(&strm);
  NanReturnValue(NanNew<Number>(res_len - strm.avail_out));
}

// exposing
void InitAll(Handle<Object> exports) {
  exports->Set(NanNew<String>("inflateRawSync"),
    NanNew<FunctionTemplate>(InflateRawSync)->GetFunction());
}

NODE_MODULE(bgzf, InitAll)
