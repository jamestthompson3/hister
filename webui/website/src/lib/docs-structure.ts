export interface DocsCategory {
	name: string;
	slugs: string[];
	color: string;
}

export const docsStructure: DocsCategory[] = [
	{
		name: "Getting Started",
		slugs: ["intro", "installing", "quickstart", "getting-started"],
		color: "indigo",
	},
	{
		name: "Reference",
		slugs: ["configuration", "query-language"],
		color: "teal",
	},
	{
		name: "Advanced Server Setup",
		slugs: ["server-setup"],
		color: "coral",
	},
];
