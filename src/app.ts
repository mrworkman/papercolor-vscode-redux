import fs from 'fs';
import YAML from 'yaml';
import { parse } from 'ts-command-line-args';

interface IArgs{
    "source-file": string;
    "target-file": string;
}

const args = parse<IArgs>({
    "source-file": String,
    "target-file": String,
});

type YamlTokenColor = {
    name:   string;
    color:  string;
} & {
    [key: string]: string[];
}

type YamlTheme = {
    name: string;
    type: string;
    namedColors: string[];
    uiColors: {
        [element: string]: string
    };
    tokenColors: YamlTokenColor[];
}

interface ISettings {
    foreground: string;
    fontStyle: string;
}

interface ITokenSpec {
    name: string;
    scope: string[];
    settings: ISettings;
}

const source: YamlTheme = YAML.parse(
    fs.readFileSync(args['source-file'], 'utf-8')
);

var target = {
    $schema: "vscode://schemas/color-theme",
    name: source.name,
    type: source.type,
    colors: source.uiColors,
    tokenColors: [] as ITokenSpec[],
};

target.tokenColors = source.tokenColors.flatMap(it => {
    var styles = Object.getOwnPropertyNames(it).filter(
        prop => prop !== 'name' &&
                prop !== 'color'
    );

    return styles.map(style => {
        var tokenSpec: ITokenSpec = {
            name: `${it.name}-${style}`,
            scope: it[style] || [],
            settings: {
                foreground: it.color,
                fontStyle: style !== 'normal' ? style : "",
            }
        }

        return tokenSpec;
    });
});

console.log(`Writing output to ${args['target-file']}...`);

fs.writeFileSync(args['target-file'], JSON.stringify(target, null, 2));

console.log("Done.");