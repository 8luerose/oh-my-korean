# oh-my-korean

Claude Code와 Codex에서 한국어 글의 AI 말투를 다듬는 스킬입니다. 상투적인 도입, 억지 대조, 과장, 번역투, 의미 없는 반복을 점검하고, 원문의 사실과 작성자 말투를 살립니다.

저장소 이름은 `oh-my-korean`, 설치 후 호출하는 스킬 이름은 `natural-korean`입니다. 공용 지침은 [스킬 원본](skills/natural-korean/SKILL.md)에 있습니다.

## 빠른 설치

사용할 Claude Code 또는 Codex와 Git이 설치된 컴퓨터에서 진행합니다. AI 도구를 사용하는 본인 계정의 터미널을 여세요. 스크립트는 기본으로 두 도구의 사용자 스킬 폴더에 설치합니다.

### macOS, WSL, Linux

터미널에서 다음 명령을 순서대로 실행하세요. WSL에서는 먼저 Ubuntu 등 사용할 배포판의 터미널을 엽니다.

```bash
git clone https://github.com/8luerose/oh-my-korean.git
cd oh-my-korean
bash install.sh
```

### Windows

PowerShell에서 다음 명령을 순서대로 실행하세요.

```powershell
git clone https://github.com/8luerose/oh-my-korean.git
Set-Location .\oh-my-korean
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1
```

`-ExecutionPolicy Bypass`는 이 명령으로 시작하는 PowerShell 프로세스에 적용됩니다.

Git 대신 GitHub의 **Code → Download ZIP**으로 받아 압축을 풀어도 됩니다. 압축을 푼 폴더에서 해당 설치 스크립트를 실행하세요.

## 지원 환경

아래 표는 스킬 설치 스크립트의 실행 환경입니다. Claude Code와 Codex 자체의 운영체제 요구사항은 각 도구의 설치 기준을 따릅니다.

| 운영체제 | 설치 파일 | 실행 환경 |
| --- | --- | --- |
| Windows | `install.ps1` | Windows PowerShell 5.1 또는 PowerShell 7 이상 |
| macOS | `install.sh` | Bash 3.2 이상과 기본 명령줄 도구 |
| WSL | `install.sh` | 배포판 내부의 Bash와 기본 명령줄 도구 |
| Ubuntu | `install.sh` | Bash와 coreutils |
| Red Hat Enterprise Linux, Rocky Linux, AlmaLinux, Fedora | `install.sh` | Bash와 coreutils |

macOS의 기본 터미널이 zsh여도 `bash install.sh`로 실행할 수 있습니다. Windows에서 Git Bash를 사용 중이면 위의 PowerShell 명령으로 설치하세요.

설치를 실행하고 결과를 확인한 환경은 Windows PowerShell 5.1과 WSL Ubuntu 22.04입니다. 설치된 네 개의 스킬 파일을 원본과 비교했고, 두 스크립트의 구문을 확인했습니다. macOS와 Red Hat 계열은 해당 환경에서의 추가 확인이 필요합니다.

## 한 도구만 선택하기

macOS, WSL, Linux에서는 `--agent`를 지정합니다.

```bash
bash install.sh --agent claude
bash install.sh --agent codex
```

Windows에서는 `-Agent`를 지정합니다.

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -Agent claude
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -Agent codex
```

`all`은 두 도구를 선택하며 생략했을 때의 기본값입니다. 설치할 도구를 선택하면 그 도구의 사용자 스킬 경로에 파일을 배치합니다.

## 설치 과정과 위치

1. 저장소의 `skills/natural-korean/SKILL.md`를 읽습니다.
2. 선택한 도구의 사용자 스킬 폴더를 만듭니다.
3. 같은 내용이 있으면 `Already current`를 표시합니다. 기존 파일과 내용이 다르면 `SKILL.md.backup.*`로 백업하고 새 파일로 교체합니다.
4. 설치 경로를 출력합니다. 해당 계정으로 여는 각 프로젝트에서 스킬을 사용할 수 있습니다.

```text
oh-my-korean/
|
+-- skills/natural-korean/SKILL.md
               |
               v
      install.sh / install.ps1
               |
               +-- Claude Code --> .claude/skills/natural-korean/SKILL.md
               |
               +-- Codex -------> .agents/skills/natural-korean/SKILL.md
```

| 실행 환경 | Claude Code 기본 위치 | Codex 기본 위치 |
| --- | --- | --- |
| macOS, WSL, Linux | `~/.claude/skills/natural-korean/SKILL.md` | `~/.agents/skills/natural-korean/SKILL.md` |
| Windows | `%USERPROFILE%\.claude\skills\natural-korean\SKILL.md` | `%USERPROFILE%\.agents\skills\natural-korean\SKILL.md` |

`~`는 해당 운영체제에 로그인한 사용자의 홈 폴더입니다. Windows의 `%USERPROFILE%`도 현재 사용자의 홈 폴더를 뜻합니다. 설치 경로는 각 도구의 사용자 스킬 위치를 따릅니다. [Claude Code 스킬 문서](https://code.claude.com/docs/en/skills), [Codex 스킬 문서](https://learn.chatgpt.com/docs/build-skills)

Claude Code의 설정 폴더를 `CLAUDE_CONFIG_DIR`로 지정했다면 그 폴더 아래의 `skills/natural-korean`에 설치합니다. 이 환경 변수에는 현재 운영체제의 절대 경로를 사용하세요. [Claude Code 설정 문서](https://code.claude.com/docs/en/settings)

Windows와 WSL은 사용자 홈 폴더가 각각 있습니다. 두 환경에서 모두 사용하려면 각 환경에서 설치 명령을 한 번씩 실행하세요. WSL 배포판을 여러 개 사용하면 사용할 배포판마다 설치합니다.

```text
Windows user
  +-- install.ps1
  |     +-- Windows .claude/skills
  |     `-- Windows .agents/skills
  |
  `-- WSL distro user
        `-- install.sh
              +-- Linux .claude/skills
              `-- Linux .agents/skills
```

## 사용 예시

설치 후 도구의 채팅 입력창에 아래 문장을 입력하세요. 호출 방법은 Claude Code의 `/스킬이름`과 Codex의 `$스킬이름` 형식을 따릅니다. [Claude Code 스킬 문서](https://code.claude.com/docs/en/skills), [Codex 스킬 문서](https://learn.chatgpt.com/docs/build-skills)

### Claude Code에서 교정하기

```text
/natural-korean 아래 글의 AI 말투를 다듬고 수정본만 보여줘.

이 기능은 단순한 메모 저장을 넘어 검색까지 지원하는 혁신적인 솔루션입니다.
```

### Codex에서 교정하기

```text
$natural-korean 아래 글의 AI 말투를 다듬고 수정본만 보여줘.

이 기능은 단순한 메모 저장을 넘어 검색까지 지원하는 혁신적인 솔루션입니다.
```

이 원문은 다음처럼 고칠 수 있습니다.

```text
이 기능으로 메모를 저장하고 검색할 수 있습니다.
```

검토만 필요하면 스킬 이름 뒤에 `어색한 표현과 그 이유만 알려줘`라고 쓰세요. 새 글을 작성하려면 `아래 메모로 안내문을 써줘. 독자는 처음 사용하는 사람이고, 존댓말로 작성해줘`처럼 목적과 독자를 알려 주세요.

```text
[Request + Text]
       |
       v
[Check purpose and scope]
       |
       v
[Edit awkward wording]
       |
       v
[Check facts and conditions]
       |
       v
[Return the requested result]
```

스킬 목록에 나타나지 않으면 같은 환경에서 새 세션을 여세요. 실제 표현과 자동 선택 여부는 사용하는 모델, 도구 설정, 대화 내용에 따라 달라질 수 있습니다.

## 업데이트

처음 내려받은 저장소 폴더에서 최신 내용을 받고 설치 명령을 다시 실행합니다.

macOS, WSL, Linux에서는 다음 명령을 사용합니다.

```bash
git pull --ff-only
bash install.sh
```

Windows에서는 다음 명령을 사용합니다.

```powershell
git pull --ff-only
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1
```

백업은 기존 설치 파일과 새 원본의 내용이 다를 때만 생깁니다. 복구하려면 원하는 `SKILL.md.backup.*` 파일의 내용을 같은 폴더의 `SKILL.md`로 복사하면 됩니다. 두 도구 중 하나의 설치에서 오류가 나면 출력된 경로와 오류를 확인한 뒤 같은 설치 명령을 다시 실행하세요.

## 원본 수정과 GitHub 반영

공용 원본은 `skills/natural-korean/SKILL.md` 한 곳에서 관리합니다. 문체 기준을 고칠 때 이 파일을 수정하고, 설치 스크립트를 다시 실행해 본인 컴퓨터에 반영하세요. 변경 사항은 저장소 폴더에서 다음과 같이 올릴 수 있습니다.

```bash
git add README.md install.sh install.ps1 skills/natural-korean/SKILL.md .gitattributes .gitignore
git commit -m "Update Korean writing skill"
git push origin main
```

## 파일 구성

```text
oh-my-korean/
|-- README.md
|-- install.sh
|-- install.ps1
|-- .gitattributes
|-- .gitignore
`-- skills/
    `-- natural-korean/
        `-- SKILL.md
```

`SKILL.md`에 두 도구가 함께 사용하는 문체 지침이 들어 있고, 설치 스크립트는 운영체제별로 그 파일을 복사합니다. `.gitattributes`는 Git으로 내려받을 때 스크립트의 줄바꿈을 LF로 맞춥니다.
