# 異世界ギルドマスターズ + 迷宮大変動 & 迷宮都市の群像劇

## ルールの設定

|                          |                                               |
| ------------------------ | --------------------------------------------- |
| ![][badge-base]          | [基本セット][link-base]                       |
| ![][badge-ext-labyrinth] | [拡張 1: 迷宮大変動][link-ext-labyrinth]      |
| ![][badge-ext-ensemble]  | [拡張 2: 迷宮都市の群像劇][link-ext-ensemble] |

[link-base]: https://bodoge.hoobby.net/games/isekai-guild-mastersomasutazu
[link-ext-labyrinth]: https://bodoge.hoobby.net/games/isekai-guild-mastersmeikyu-daihendou
[link-ext-ensemble]: https://bodoge.hoobby.net/games/dungeon-towns-ensemble

<!-- -->

[badge-base]: https://img.shields.io/badge/基本-gray?style=flat-square
[badge-ext-labyrinth]: https://img.shields.io/badge/拡張-迷宮-b91c1c?style=flat-square
[badge-ext-ensemble]: https://img.shields.io/badge/拡張-群像劇-4d7c0f?style=flat-square

<!-- -->

1. マップの選択
    1. ![][badge-base] 六角形マップ(2-4 人向け)
    2. ![][badge-base] 古墳型マップ(4-5 人向け)
    3. ![][badge-base] チュートリアルマップ(2-5 人向け)
        1. 一部カードを抜く処理を追加
    4. ![][badge-ext-labyrinth] 大深度迷宮 表面
    5. ![][badge-ext-labyrinth] 大深度迷宮 裏面
2. ![][badge-base] 追加ルール「フラッグチップ」
3. ![][badge-base] 追加ルール「禁止区域」
    - 2, 3 人プレイの場合のみ
4. ![][badge-base] 追加ルール「セットアップドラフト」
5. ![][badge-base] 追加ルール「高難易度ボスタイル」
6. ![][badge-base] 追加ルール「偵察隊」
7. ![][badge-ext-labyrinth] 追加イベントカード・レガリアカード
    - 大深度迷宮マップの場合、使用必須
8. ![][badge-ext-labyrinth] 「変動迷宮」
    - 大深度迷宮マップの場合、使用必須
9. ![][badge-ext-labyrinth] 追加ルール「移り変わる迷宮」
    - 妨害カードの導入
10. ![][badge-ext-labyrinth] 追加ルール「ギルドの掲示板」
11. ![][badge-ext-labyrinth] 長時間ゲームルール「汚染領域」
12. ![][badge-ext-labyrinth] 「豊かな季節」ターントラック
    - 「ギルドの掲示板」使用時は季節ボーナスがないため無関係
13. ![][badge-ext-ensemble] 追加イベントカード
    - 尖ったカードが多いため注意。合わないものは抜く
14. ![][badge-ext-ensemble] 追加ルール「物語の始まり」
    - プロローグカード
15. ![][badge-ext-ensemble] 追加ルール「苦難の物語」
    - 導入する場合、「物語の始まり」が必須
16. ![][badge-ext-ensemble] 追加ルール「ハッピーエンドを求めて」
    - 導入する場合、「物語の始まり」も推奨

## スクリプト

大文字で始まるスクリプトはトークンやタイルなどのオブジェクトから require で呼び出すためのスクリプトです

小文字で始まるスクリプトは大文字で始まるスクリプトから呼び出されるユーティリティスクリプトです

## GMNotes

チップの値などタグで管理することに適していないスカラ値は JSON にして GMNotes 欄に保存しています

`object.lua`の`Object_getValue`, `Object_getValue_container`でパースして使用できます

```lua
-- GMNotes 欄で { "value": 20 } が設定されているobject
local object = getObjectFromGUID("object_guid")

-- 20
local value = Object_getValue(object)
```

```lua
-- GMNotes 欄で { "value": 20 }が設定されているobject
-- が入っているcontainer
local container = getObjectFromGUID("contaier_guid")
-- https://api.tabletopsimulator.com/object/#getobjects-containers
local objectsTable = container.getObjects(container)

for _, subTable in ipairs(objectsSubTable) do
    -- 20
    local value = Object_getValue_container(subTable)
end
```

## tag

-   `snappoint_mapTile`: 迷宮タイルのスナップポイント
-   `snappoint_mapTile-boss-star2`: ボス迷宮タイルのスナップポイント
-   `snappoint_mapTile-openedFromBegin`: 最初から表になっている迷宮タイルのスナップポイント

## 外部アセット

-   背景
    -   https://steamcommunity.com/sharedfiles/filedetails/?id=2866355400

## 開発環境

-   VSCode
-   [rolandostar.tabletopsimulator-lua](https://marketplace.visualstudio.com/items?itemName=rolandostar.tabletopsimulator-lua) v2.0.0-rc1
    -   https://github.com/rolandostar/tabletopsimulator-lua-vscode
    -   Marketplace のものはまだ 1.x なので main ブランチからビルドする必要がある
