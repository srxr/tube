module github.com/prologic/tube

go 1.14

require (
	github.com/GeertJohan/go.rice v1.0.0
	github.com/dhowden/tag v0.0.0-20190519100835-db0c67e351b1
	github.com/dustin/go-humanize v1.0.0
	github.com/fsnotify/fsnotify v1.4.7
	github.com/google/uuid v1.1.1 // indirect
	github.com/gorilla/handlers v1.4.2
	github.com/gorilla/mux v1.7.2
	github.com/prologic/bitcask v0.3.5
	github.com/prologic/vimeodl v0.0.0-20200328030915-d2b0e6272c23
	github.com/renstrom/shortuuid v3.0.0+incompatible
	github.com/rylio/ytdl v1.0.4
	github.com/sirupsen/logrus v1.4.2
	github.com/spf13/pflag v1.0.5
	github.com/wybiral/feeds v1.1.1
)

replace github.com/rylio/ytdl => github.com/Andreychik32/ytdl v0.6.3
