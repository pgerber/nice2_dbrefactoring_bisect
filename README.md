# Find Git Commit that Broke DB Refactoring using Git Bisect

## usage

1. `cd ${THIS_REPOSITORY}`
2. `git clone ssh://${USERNAME}@git.tocco.ch:29418/nice2.git`
3. `cd nice2`
4. `git bisect start ${BAD} ${GOOD} ${CUSTOMER}`
   * BAD: first known bad commit
   * GOOD: last known good commit
   * CUSTOMER: customer to build

   example: `git bisect start HEAD 991c68487e16d821309c1df3e4d2de89a903cadd testlight`
5. `git bisect run ../run.sh`

## show status

`git bisect log`
