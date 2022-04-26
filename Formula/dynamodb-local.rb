class DynamodbLocal < Formula
  # see http://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBLocal.html
  desc "Client-side database and server imitating DynamoDB"
  homepage "https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Tools.DynamoDBLocal.html"
  head "https://s3.us-west-2.amazonaws.com/dynamodb-local/dynamodb_local_latest.tar.gz"

  depends_on "openjdk"
  depends_on "wget"

  def data_path
    var/"data/dynamodb-local"
  end

  def log_path
    var/"log/dynamodb-local.log"
  end

  def bin_wrapper; <<~EOS
    #!/bin/sh
    cd #{data_path}
    
    export JAVA_HOME="${JAVA_HOME:-#{ENV['HOMEBREW_PREFIX']}/opt/openjdk/libexec/openjdk.jdk/Contents/Home}"
    export AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID:-X}"
    export AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY:-X}"
    export DYNAMODB_LOCAL_PATH="${DYNAMODB_LOCAL_PATH:-$HOME/.localdev/dynamodb}"

    mkdir -p $DYNAMODB_LOCAL_PATH
    exec java -Djava.library.path=#{libexec}/DynamodbLocal_lib -jar #{libexec}/DynamoDBLocal.jar -sharedDb -dbPath $DYNAMODB_LOCAL_PATH $@
    EOS
  end

  def install
    prefix.install %w[LICENSE.txt README.txt THIRD-PARTY-LICENSES.txt]
    libexec.install %w[DynamoDBLocal_lib DynamoDBLocal.jar]
    (bin/"dynamodb-local").write(bin_wrapper)
  end

  def post_install
    data_path.mkpath
    if RUBY_PLATFORM =~ /arm64.*darwin/
      # https://stackoverflow.com/questions/66635424/dynamodb-local-setup-on-m1-apple-silicon-mac
      system "wget", "-O", "#{libexec}/DynamodbLocal_lib/libsqlite4java-osx.dylib", "https://repo1.maven.org/maven2/io/github/ganadist/sqlite4java/libsqlite4java-osx-aarch64/1.0.392/libsqlite4java-osx-aarch64-1.0.392.dylib"
    end
  end

  def caveats; <<~EOS
    DynamoDB Local supports the Java Runtime Engine (JRE) version 6.x or
    newer; it will not run on older JRE versions.

    In this release, the local database file format has changed;
    therefore, DynamoDB Local will not be able to read data files
    created by older releases.

    Data: #{data_path}
    Logs: #{log_path}

    Note: on M1s an additional native library is installed for sqlite4java
      detected architecture is: #{RUBY_PLATFORM}
    EOS
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/bin/dynamodb-local"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <false/>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/dynamodb-local</string>
      </array>
      <key>StandardErrorPath</key>
      <string>#{log_path}</string>
    </dict>
    </plist>
    EOS
  end

  test do
    system bin/"dynamodb-local", "-help"
  end
end
