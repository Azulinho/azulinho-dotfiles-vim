" Java syntax file - simplified version to avoid markdown dependency issues
" This replaces the system Java syntax file to prevent markdown group errors

if exists("b:current_syntax")
  finish
endif

" Basic Java syntax highlighting without markdown dependencies
syn keyword javaType boolean byte char double float int long short void
syn keyword javaType Boolean Byte Character Double Float Integer Long Short String
syn keyword javaStatement break case catch continue default do else finally for
syn keyword javaStatement if return switch throw try while
syn keyword javaModifier abstract final native private protected public static strictfp synchronized transient volatile
syn keyword javaConstant false null true
syn keyword javaException Exception RuntimeException

" Strings and characters
syn region javaString start=+"+ end=+"+ end=+$+ contains=javaSpecialChar,javaSpecialError
syn region javaString start=+'+ end=+'+ end=+$+ contains=javaSpecialChar,javaSpecialError
syn match javaSpecialChar "\\\d\d\d\|\\." contained

" Comments
syn region javaComment start="/\*" end="\*/" contains=javaTodo
syn region javaComment start="//" end="$" contains=javaTodo
syn keyword javaTodo TODO FIXME XXX contained

" Numbers
syn match javaNumber "\<\(0[0-7]*\|0[xX]\x\+\|\d\+\)[lL]\=\>"
syn match javaNumber "\(\.\d\+\|\d\+\.\d*\|\d\+\.\)\([eE][-+]\=\d\+\)\=[fFdD]\="
syn match javaNumber "\d\+[eE][-+]\=\d\+[fFdD]\="
syn match javaNumber "\d\+\([eE][-+]\=\d\+\)\=[fFdD]\="

" Annotations
syn match javaAnnotation "@\w\+"

" Class and interface declarations
syn keyword javaClassDecl class interface enum
syn keyword javaScopeDecl extends implements

" Method declarations
syn keyword javaStorageClass super this

" Operators
syn match javaOperator "[-+*/%=<>!&|^~?:]"
syn match javaOperator "=="
syn match javaOperator "!="
syn match javaOperator "<="
syn match javaOperator ">="
syn match javaOperator "&&"
syn match javaOperator "||"
syn match javaOperator "++"
syn match javaOperator "--"
syn match javaOperator "<<"
syn match javaOperator ">>"
syn match javaOperator ">>>"
syn match javaOperator "+="
syn match javaOperator "-="
syn match javaOperator "*="
syn match javaOperator "/="
syn match javaOperator "%="
syn match javaOperator "&="
syn match javaOperator "|="
syn match javaOperator "^="
syn match javaOperator "<<="
syn match javaOperator ">>="
syn match javaOperator ">>>="

" Parentheses and brackets
syn match javaParen "("
syn match javaParen ")"
syn match javaBracket "{"
syn match javaBracket "}"
syn match javaArrayBracket "\["
syn match javaArrayBracket "\]"

" Define the default highlighting
hi def link javaType Type
hi def link javaStatement Statement
hi def link javaModifier StorageClass
hi def link javaConstant Constant
hi def link javaException Exception
hi def link javaString String
hi def link javaSpecialChar SpecialChar
hi def link javaComment Comment
hi def link javaTodo Todo
hi def link javaNumber Number
hi def link javaAnnotation PreProc
hi def link javaClassDecl Keyword
hi def link javaScopeDecl Keyword
hi def link javaStorageClass Special
hi def link javaOperator Operator
hi def link javaParen Delimiter
hi def link javaBracket Delimiter
hi def link javaArrayBracket Delimiter

let b:current_syntax = "java"