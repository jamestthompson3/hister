// Package stackoverflow provides an extractor for stackoverflow.com questions.
package stackoverflow

import (
	"fmt"
	"strings"

	"github.com/asciimoo/hister/server/document"
	"github.com/asciimoo/hister/server/sanitizer"
	"github.com/asciimoo/hister/server/types"

	"github.com/PuerkitoBio/goquery"
)

const matchURLPrefix = "https://stackoverflow.com/questions/"

type StackoverflowExtractor struct{}

func (e *StackoverflowExtractor) Name() string {
	return "Stackoverflow"
}

func (e *StackoverflowExtractor) Match(d *document.Document) bool {
	return strings.HasPrefix(d.URL, matchURLPrefix) && len(d.URL) > len(matchURLPrefix)
}

func (e *StackoverflowExtractor) Extract(d *document.Document) (bool, error) {
	return true, nil
}

func (e *StackoverflowExtractor) Preview(d *document.Document) (types.PreviewResponse, bool, error) {
	// TODO include more details about the question/answers
	// TODO rewrite URLs and references to absolute
	doc, err := goquery.NewDocumentFromReader(strings.NewReader(d.HTML))
	if err != nil {
		return types.PreviewResponse{}, false, err
	}

	// remove the "copy" panel
	doc.Find("pre div").Remove()

	question, err := doc.Find(".js-post-body").Html()
	if err != nil {
		return types.PreviewResponse{}, false, err
	}

	answers := make([]string, 0)
	for i, a := range doc.Find(".answercell .s-prose").EachIter() {
		h, err := a.Html()
		if err != nil {
			continue
		}
		answers = append(answers, fmt.Sprintf("<h2>Answer #%d</h2>%s", i+1, h))
	}
	res := fmt.Sprintf(
		"<h2>Question</h2>%s%s",
		question,
		strings.Join(answers, "<hr />"),
	)
	return types.PreviewResponse{Content: sanitizer.SanitizeHTML(res)}, false, nil
}
