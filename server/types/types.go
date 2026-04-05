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
