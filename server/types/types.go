package types

// DocType represents the type of an indexed document.
type DocType int

const (
	Web DocType = iota
	Local
)

var DocTypeNames = map[string]DocType{
	"web":   Web,
	"file":  Local,
	"local": Local,
}

// PreviewResponse holds the result of a document preview operation.
// Template should be left blank to use the default template.
type PreviewResponse struct {
	Content  string
	Template string
}

// ExtractorState signals to the extractor chain how processing should proceed
// after an extractor returns.
type ExtractorState int

const (
	// ExtractorStop means the extractor handled the document successfully;
	// stop the chain and return a successful result.
	ExtractorStop ExtractorState = iota

	// ExtractorContinue means the extractor was inconclusive; try the next
	// matching extractor in the chain.
	ExtractorContinue

	// ExtractorAbort means a fatal error occurred; stop the chain immediately
	// and propagate the error to the caller.
	ExtractorAbort
)
