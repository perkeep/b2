PKGS := $$(go list)
SRCDIRS := $$(go list -f '{{.Dir}}' ./...)
VETTERS := "asmdecl,assign,atomic,bools,buildtag,cgocall,composites,copylocks,errorsas,httpresponse,loopclosure,lostcancel,nilfunc,printf,shift,stdmethods,structtag,tests,unmarshal,unreachable,unsafeptr,unusedresult"

check: vet gofmt ineffassign misspell staticcheck unconvert unparam

test: 
	@go test -race -timeout=1m -vet="${VETTERS}" $(PKGS)

ineffassign:
	@go install github.com/gordonklaus/ineffassign@latest
	@find $(SRCDIRS) -name '*.go' | xargs $$(go env GOPATH)/bin/ineffassign

errcheck:
	@go install github.com/kisielk/errcheck@v1.6.0
	@$$(go env GOPATH)/bin/errcheck $(PKGS)

gofmt:
	@test -z "$(shell gofmt -s -l -d -e $(SRCDIRS) | tee /dev/stderr)"

misspell:
	@go install github.com/client9/misspell/cmd/misspell@latest
	@$$(go env GOPATH)/bin/misspell -locale="US" -error -source="text" **/*

staticcheck:
	@go install honnef.co/go/tools/cmd/staticcheck@latest
	@$$(go env GOPATH)/bin/staticcheck -go 1.16 -checks all -tests $(PKGS)

unconvert:
	@go install github.com/mdempsky/unconvert@latest
	@$$(go env GOPATH)/bin/unconvert -v $(PKGS)

unparam:
	@go install mvdan.cc/unparam@latest
	@$$(go env GOPATH)/bin/unparam ./...

vet:
	@go vet $(PKGS)

# Based on https://github.com/cloudflare/hellogopher - v1.1 - MIT License
#
# Copyright (c) 2017 Cloudflare
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
