package importers

import (
	"fmt"
	"strings"

	"github.com/kkdai/youtube/v2"
)

type YoutubeImporter struct{}

func (i *YoutubeImporter) GetVideoInfo(url string) (videoInfo VideoInfo, err error) {
	if strings.HasPrefix(strings.ToLower(url), "youtube:") {
		url = strings.TrimSpace(strings.SplitN(url, ":", 2)[1])
	}

	client := &youtube.Client{}
	video, err := client.GetVideo(url)
	if err != nil {
		err = fmt.Errorf("error: %v", err)
		return
	}
	formats := video.Formats.FindByType("video")

	if len(formats) == 0 {
		err = fmt.Errorf("error: no found format")
		return
	}

	// Get the highest quality video
	videoURL, err := client.GetStreamURL(video, &formats[0])
	if err != nil {
		err = fmt.Errorf("error: %v", err)
		return
	}

	if len(video.Thumbnails) == 0 {
		err = fmt.Errorf("error: no found thumbnails")
	}
	// Pick the highest quality thumbnail
	thumbnail := video.Thumbnails[0].URL

	videoInfo.VideoURL = videoURL
	videoInfo.ThumbnailURL = thumbnail
	videoInfo.ID = video.ID
	videoInfo.Title = video.Title
	videoInfo.Description = video.Description

	return
}
