# natural-korean 등록 안내

[README로 돌아가기](../README.md)

스킬 등록은 AI 도구가 읽는 폴더에 **지침 두 파일을 복사하는 작업**입니다. 계정 가입이나 별도 서버가 필요하지 않습니다. Claude Code·Codex 자체의 설치와 로그인은 먼저 마쳐야 합니다.

## 1. 내 환경에 맞는 파일 고르기

| 사용 환경 | 설치 파일 | 필요한 실행 환경 |
| --- | --- | --- |
| Windows | [install.ps1](../install.ps1) | Windows PowerShell 5.1 또는 Windows의 PowerShell 7 이상 |
| macOS | [install.sh](../install.sh) | Bash 3.2 이상과 기본 명령줄 도구 |
| WSL | [install.sh](../install.sh) | 사용할 배포판 내부의 Bash |
| Ubuntu | [install.sh](../install.sh) | Bash와 기본 명령줄 도구 |
| Red Hat Enterprise Linux·Rocky Linux·AlmaLinux·Fedora | [install.sh](../install.sh) | Bash와 기본 명령줄 도구 |

이 표는 **설치 스크립트의 대상 환경**입니다. Claude Code와 Codex 앱 자체의 OS 지원 조건은 각 제품의 안내를 따릅니다. macOS·Red Hat 계열에서의 실제 실행 확인은 아직 하지 않았습니다.

## 2. 저장소 내려받기

Git이 있으면 원하는 작업 폴더에서 실행합니다.

```bash
git clone https://github.com/8luerose/oh-my-korean.git
cd oh-my-korean
```

Git이 없다면 저장소의 **Code → Download ZIP**으로 내려받아 압축을 풉니다. 그 안에서 `README.md`, `install.sh`, `install.ps1`이 보이는 폴더를 여세요. ZIP을 받은 경우에는 `git pull` 대신 새 ZIP을 다시 받아 업데이트합니다.

## 3. 등록하기

Windows PowerShell:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1
```

macOS·WSL·Linux:

```bash
bash install.sh
```

기본값은 두 도구입니다. 하나만 사용하면 아래 옵션을 붙입니다.

| 대상 | Windows 옵션 | Bash 옵션 |
| --- | --- | --- |
| Claude Code만 | `-Agent claude` | `--agent claude` |
| Codex만 | `-Agent codex` | `--agent codex` |
| 둘 다 | `-Agent all` 또는 생략 | `--agent all` 또는 생략 |

일반 사용자 계정으로 실행합니다. 기본 경로에서는 관리자 권한이나 `sudo`가 필요하지 않습니다.

### 설치 위치

| 환경 | Claude Code | Codex |
| --- | --- | --- |
| Windows | `%USERPROFILE%\.claude\skills\natural-korean\` | `%USERPROFILE%\.agents\skills\natural-korean\` |
| macOS·WSL·Linux | `~/.claude/skills/natural-korean/` | `~/.agents/skills/natural-korean/` |

`~`와 `%USERPROFILE%`은 해당 환경에서 로그인한 사용자의 홈 폴더를 뜻합니다. 스크립트는 이 경로를 실행한 컴퓨터에서 구하므로 제작자의 사용자 이름이나 경로가 필요하지 않습니다. [Claude Code 사용자 스킬 경로](https://code.claude.com/docs/en/skills), [Codex 사용자 스킬 경로](https://learn.chatgpt.com/docs/build-skills)

Claude Code에서 `CLAUDE_CONFIG_DIR`을 설정했다면 기본 `.claude` 대신 그 폴더 아래의 `skills/natural-korean`을 사용합니다. 이 변수에는 현재 OS의 절대 경로를 지정하세요. [Claude Code 설정 위치](https://code.claude.com/docs/en/settings)

각 설치 폴더는 다음 구조여야 합니다.

```text
natural-korean/
|-- SKILL.md
`-- references/
    `-- rules.json
```

**SKILL.md만 복사하면 안 됩니다.** 스킬은 작업할 때 상대 경로의 `references/rules.json`을 읽습니다.

### Windows와 WSL을 함께 쓰는 경우

```text
Windows PowerShell
  `-- install.ps1 --> Windows user skill folders

WSL Ubuntu terminal
  `-- install.sh --> Ubuntu user skill folders

Another WSL distro
  `-- install.sh --> That distro's user skill folders
```

각 환경의 사용자 폴더가 다릅니다. Windows에 등록했다고 WSL에도 등록되는 것은 아닙니다. 사용할 배포판과 계정에서 각각 설치기를 실행하세요.

## 4. 사용하기

같은 컴퓨터·같은 환경의 AI 채팅 입력창에서 호출합니다.

Claude Code:

```text
/natural-korean 아래 글을 교정해 주세요.

React 와 연결합니다.
```

Codex CLI·IDE:

```text
$natural-korean 아래 글을 교정해 주세요.

React 와 연결합니다.
```

Claude Code는 `/스킬이름`, Codex CLI·IDE는 `$`를 통한 스킬 선택 또는 `/skills`를 사용합니다. 데스크톱 앱에서는 제공되는 스킬 선택 목록에서 이름을 찾으세요. [Claude Code 호출 방식](https://code.claude.com/docs/en/skills), [Codex 호출 방식](https://learn.chatgpt.com/docs/build-skills)

목록에 보이지 않으면 새 세션을 열거나 앱을 다시 시작합니다. 모델이 자동으로 선택할 수도 있지만, 적용 여부를 분명히 하려면 이름을 직접 선택해 사용하세요.

## 수동으로 등록하기

설치 스크립트를 실행하기 어려우면 저장소의 `skills/natural-korean` **폴더 전체**를 위 표에 나온 도구별 `skills` 폴더 아래로 복사합니다. `natural-korean/natural-korean`처럼 폴더를 중복으로 만들지 않도록 확인하세요.

기존 `natural-korean`이 있으면 먼저 별도 위치에 보관합니다. 자동 설치기는 변경 파일을 백업하지만 수동 복사는 사용자가 백업해야 합니다. 실제 설치 폴더에 두 파일이 있는지 확인한 뒤 새 세션에서 스킬을 선택합니다.

## 업데이트와 복구

Git으로 받은 저장소 폴더에서:

```bash
git pull --ff-only
```

그다음 처음 사용한 설치 명령을 다시 실행합니다. 개인적으로 수정한 저장소 파일 때문에 `git pull`이 멈추면 변경을 먼저 보관하고 충돌을 해결하세요. 강제 덮어쓰기는 하지 않습니다.

설치기는 두 원본 파일이 모두 있는지 먼저 확인합니다. 같으면 `Already current`, 바뀌었으면 `Backup`과 `Installed` 경로를 표시합니다. 다른 사용자 파일은 지우지 않습니다.

```text
natural-korean/
|-- SKILL.md
|-- SKILL.md.backup.<unique-id>
`-- references/
    |-- rules.json
    `-- rules.json.backup.<unique-id>
```

복구할 때는 교체 전 버전에 해당하는 백업 내용을 각각 `SKILL.md`와 `references/rules.json`로 복사합니다. 백업 파일명과 수정 시각을 확인해 같은 업데이트 이전의 조합을 고르세요. 초기의 한 파일 버전은 `SKILL.md` 백업만 있을 수 있습니다. 새 규칙 파일이 남아 있어도 그 초기 스킬은 이를 읽지 않습니다.

파일 교체는 파일별로 진행합니다. 설치 도중 오류가 나면 오류의 경로를 확인하고 같은 명령을 다시 실행해 두 파일을 최신 상태로 맞추세요.

## 자주 생기는 문제

| 상황 | 확인할 내용 |
| --- | --- |
| `rules.json`을 찾을 수 없다고 나옴 | 저장소 전체를 받았는지, `references` 폴더도 복사했는지 확인 |
| 설치했는데 목록에 없음 | 설치한 OS·WSL 배포판·사용자와 실행한 AI 도구의 환경이 같은지 확인하고 새 세션 열기 |
| 같은 이름이 두 번 나타남 | 프로젝트 폴더에도 같은 이름의 스킬이 있는지 확인. 자동으로 합쳐진다고 생각하지 않기 |
| PowerShell 정책 때문에 실행 불가 | 예시의 프로세스 단위 옵션을 사용하거나, 조직 정책을 따라 수동 복사 |
| 링크 관련 오류가 나옴 | 기존 스킬 또는 references 폴더가 심볼릭 링크인지 확인. 이 설치기는 해당 링크를 임의로 덮어쓰지 않음 |
| `Already current`만 나옴 | 정상 동작. 설치 파일과 원본이 이미 같음 |
| 규칙대로 교정하지 않음 | 스킬이 실제 선택됐는지와 rules.json 읽기 가능 여부를 확인. 충돌하는 대화 지시가 없는지도 확인 |

같은 이름의 프로젝트 스킬과 사용자 스킬은 도구마다 처리 방식이 다릅니다. [Claude Code 이름 충돌 규칙](https://code.claude.com/docs/en/skills#resolve-skills-that-share-a-name), [Codex 검색 위치와 중복 이름](https://learn.chatgpt.com/docs/build-skills)

## 별도 폴더에 복사해 확인하기

설치 내용을 사용자 스킬 폴더에 반영하기 전에 살펴보려는 경우에만 사용합니다.

```bash
bash install.sh --install-root /tmp/oh-my-korean-preview
```

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -InstallRoot C:\Temp\oh-my-korean-preview
```

지정한 절대 경로 아래에 `.claude`와 `.agents`를 만듭니다. 이 옵션을 쓰면 `CLAUDE_CONFIG_DIR`은 무시합니다. **이 위치에 복사하는 것만으로 AI 도구에 자동 등록되지는 않습니다.** 실제 등록은 기본 설치 명령이나 수동 등록 방법을 사용하세요.
